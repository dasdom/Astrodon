//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHTimelineWindowController.h"
#import "DDHTimelineViewController.h"
#import "DDHTimelineViewControllerDelegate.h"
#import "DDHMediaAttachment.h"
#import "DDHImageViewerViewController.h"
#import "DDHAccount.h"
#import "DDHAccountViewController.h"
#import "DDHToot.h"
#import "DDHStatusContextViewController.h"

NSString * const reloadIdentifier = @"reloadIdentifier";
NSString * const spinnerIdentifier = @"spinnerIdentifier";

@interface DDHTimelineWindowController () <NSToolbarDelegate, DDHTimelineViewControllerDelegate>
@property (strong) id<DDHTimelineWindowControllerDelegate> delegate;
@property (strong) DDHImageLoader *imageLoader;
@property (strong) DDHAPIClient *apiClient;
@end

@implementation DDHTimelineWindowController

- (instancetype)initWithDelegate:(id<DDHTimelineWindowControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {
  DDHTimelineViewController *timeLineViewController = [[DDHTimelineViewController alloc] initWithDelegate:self imageLoader:imageLoader apiClient:apiClient];
  timeLineViewController.title = @"Timeline";

  NSWindow *window = [NSWindow windowWithContentViewController:timeLineViewController];
  if (self = [super initWithWindow:window]) {
    _delegate = delegate;
    _imageLoader = imageLoader;
    _apiClient = apiClient;

    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Timeline"];
    toolbar.delegate = self;
    [toolbar insertItemWithItemIdentifier:reloadIdentifier atIndex:0];

    window.toolbar = toolbar;
  }
  return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (void)reloadTimeline:(id)sender {
  DDHTimelineViewController *timelineViewController = (DDHTimelineViewController *)self.contentViewController;
  [self.window.toolbar insertItemWithItemIdentifier:spinnerIdentifier atIndex:0];
  [timelineViewController loadToots:sender withCompletionHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.window.toolbar removeItemAtIndex:0];
    });
  }];
}

// MARK: - NSToolbarDelegate
- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  return @[reloadIdentifier];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  return @[reloadIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {

  NSToolbarItem *toolBarItem;
  if ([itemIdentifier isEqualToString:reloadIdentifier]) {
    NSToolbarItem *reloadItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    reloadItem.image = [NSImage imageWithSystemSymbolName:@"arrow.clockwise" accessibilityDescription:@"reload"];
    reloadItem.target = self;
    reloadItem.action = @selector(reloadTimeline:);
    toolBarItem = reloadItem;
  } else if ([itemIdentifier isEqualToString:spinnerIdentifier]) {
    NSToolbarItem *spinnerItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    NSProgressIndicator *progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
    progressIndicator.style = NSProgressIndicatorStyleSpinning;
    [progressIndicator startAnimation:nil];
    spinnerItem.view = progressIndicator;
    toolBarItem = spinnerItem;
  } else {
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolBarItem = item;
  }
  return toolBarItem;
}

// MARK: - DDHTimelineViewControllerDelegate
- (void)viewController:(NSViewController *)viewController didClickItem:(id)item {
  if ([item isKindOfClass:[NSURL class]]) {
    NSURL *url = (NSURL *)item;
    NSLog(@"url: %@", url);
    [NSWorkspace.sharedWorkspace openURL:url];
  } else if ([item isKindOfClass:[DDHMediaAttachment class]]) {
    DDHMediaAttachment *attachment = (DDHMediaAttachment *)item;
    DDHImageViewerViewController *imageViewController = [[DDHImageViewerViewController alloc] initWithMediaAttachment:attachment imageLoader:self.imageLoader];
    [viewController presentViewControllerAsModalWindow:imageViewController];
  } else if ([item isKindOfClass:[DDHAccount class]]) {
    DDHAccount *account = (DDHAccount *)item;
    DDHAccountViewController *accountViewController = [[DDHAccountViewController alloc] initWithAccount:account imageLoader:self.imageLoader];
    [viewController presentViewControllerAsModalWindow:accountViewController];
  } else if ([item isKindOfClass:[DDHToot class]]) {
    DDHToot *toot = (DDHToot *)item;
    DDHStatusContextViewController *statusContextViewController = [[DDHStatusContextViewController alloc] initWithAPIClient:self.apiClient toot:toot.tootToShow imageLoader:self.imageLoader];
    [viewController presentViewControllerAsModalWindow:statusContextViewController];
  }
}

@end
