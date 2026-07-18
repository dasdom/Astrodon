//  Created by Dominik Hauser on 05.07.26.
//
//


#import "DDHMainViewController.h"
#import "DDHTimelineViewController.h"
#import "DDHMediaAttachment.h"
#import "DDHImageViewerViewController.h"
#import "DDHAccount.h"
#import "DDHAccountViewController.h"
#import "DDHToot.h"
#import "DDHStatusContextViewController.h"
#import "DDHTag.h"
#import "DDHTimelineWindowController.h"

@interface DDHMainViewController () <DDHTimelineViewControllerDelegate>
@property (strong) NSSplitViewController *splitViewController;
@property (strong) NSViewController *detailHostViewController;
@property (strong) DDHImageLoader *imageLoader;
@property (strong) DDHAPIClient *apiClient;
@end

@implementation DDHMainViewController

- (instancetype)initWithImageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _imageLoader = imageLoader;
    _apiClient = apiClient;
    _splitViewController = [[NSSplitViewController alloc] init];

    _detailHostViewController = [[NSViewController alloc] init];

    [self addChildViewController:_splitViewController];

    self.view.frame = NSMakeRect(0, 0, 600, 700);

    NSView *view = _splitViewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];

    [NSLayoutConstraint activateConstraints:@[
      [view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
      [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
      [view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
      [view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  DDHTimelineViewController *timelineViewController = [[DDHTimelineViewController alloc] initWithDelegate:self imageLoader:self.imageLoader apiClient:self.apiClient];
  NSSplitViewItem *timelineItem = [NSSplitViewItem splitViewItemWithViewController:timelineViewController];
  timelineItem.minimumThickness = 400;
  [self.splitViewController addSplitViewItem:timelineItem];

  NSSplitViewItem *detailItem = [NSSplitViewItem splitViewItemWithViewController:self.detailHostViewController];
  detailItem.minimumThickness = 400;
  detailItem.collapsed = YES;
  [self.splitViewController addSplitViewItem:detailItem];
}

- (DDHTimelineViewController *)homeViewController {
  return (DDHTimelineViewController *)self.splitViewController.splitViewItems.firstObject.viewController;
}

// MARK: - DDHTimelineViewControllerDelegate
- (void)viewController:(NSViewController *)viewController didClickItem:(id)item {
  if ([item isKindOfClass:[NSURL class]]) {
    // Link in post
    NSURL *url = (NSURL *)item;
    NSLog(@"url: %@", url);
    [NSWorkspace.sharedWorkspace openURL:url];

  } else if ([item isKindOfClass:[DDHMediaAttachment class]]) {
    // Image
    DDHMediaAttachment *attachment = (DDHMediaAttachment *)item;
    DDHImageViewerViewController *imageViewController = [[DDHImageViewerViewController alloc] initWithMediaAttachment:attachment imageLoader:self.imageLoader];
    [viewController presentViewControllerAsModalWindow:imageViewController];

  } else if ([item isKindOfClass:[DDHAccount class]]) {
    // Account
    DDHAccount *account = (DDHAccount *)item;
    DDHAccountViewController *accountViewController = [[DDHAccountViewController alloc] initWithAccount:account imageLoader:self.imageLoader apiClient:self.apiClient];
    [viewController presentViewControllerAsModalWindow:accountViewController];

  } else if ([item isKindOfClass:[DDHToot class]]) {
    // Thread
    DDHToot *toot = (DDHToot *)item;
    DDHStatusContextViewController *statusContextViewController = [[DDHStatusContextViewController alloc] initWithAPIClient:self.apiClient toot:toot.tootToShow imageLoader:self.imageLoader];

    [self embedDetailViewController:statusContextViewController];

  } else if ([item isKindOfClass:[DDHTag class]]) {
    // Tag
    DDHTag *hashtag = (DDHTag *)item;

    DDHTimelineWindowController *windowController = [[DDHTimelineWindowController alloc] initWithDelegate:self hashtag:hashtag.name imageLoader:self.imageLoader apiClient:self.apiClient];

    NSWindow *hashtagWindow = windowController.window;
    [hashtagWindow makeKeyAndOrderFront:self];

    NSRect windowRect = viewController.view.window.frame;
    windowRect.origin.x = windowRect.origin.x + windowRect.size.width / 2;
    [hashtagWindow setFrameOrigin:windowRect.origin];
  }
}

- (void)embedDetailViewController:(NSViewController *)detailViewController {
  if (self.splitViewController.splitViewItems[1].collapsed) {
    NSRect viewFrame = self.view.window.frame;
    viewFrame.size.width = viewFrame.size.width + 400;
    [self.view.window setFrame:viewFrame display:YES];

    self.splitViewController.splitViewItems[1].collapsed = NO;
  }

  if ([self.detailHostViewController.childViewControllers count] > 0) {
    [self.detailHostViewController removeChildViewControllerAtIndex:0];
    [self.detailHostViewController.view.subviews[0] removeFromSuperview];
  }

  [self.detailHostViewController addChildViewController:detailViewController];
  [self.detailHostViewController.view addSubview:detailViewController.view];
  detailViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

  [NSLayoutConstraint activateConstraints:@[
    [detailViewController.view.topAnchor constraintEqualToAnchor:self.detailHostViewController.view.topAnchor],
    [detailViewController.view.leadingAnchor constraintEqualToAnchor:self.detailHostViewController.view.leadingAnchor],
    [detailViewController.view.bottomAnchor constraintEqualToAnchor:self.detailHostViewController.view.bottomAnchor],
    [detailViewController.view.trailingAnchor constraintEqualToAnchor:self.detailHostViewController.view.trailingAnchor],
  ]];
}

- (void)viewControllerStartedLoading:(NSViewController *)viewController { 

}


- (void)viewControllerStoppedLoading:(NSViewController *)viewController { 

}

- (void)closeDetails {
  self.splitViewController.splitViewItems.lastObject.collapsed = YES;
}

@end
