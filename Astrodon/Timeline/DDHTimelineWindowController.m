//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHTimelineWindowController.h"
#import "DDHTimelineViewController.h"
#import "DDHTimelineViewControllerDelegate.h"

NSString * const reloadIdentifier = @"reloadIdentifier";
NSString * const spinnerIdentifier = @"spinnerIdentifier";
NSString * const composeIdentifier = @"composeIdentifier";

@interface DDHTimelineWindowController () <DDHTimelineViewControllerDelegate, NSToolbarDelegate>
@property (strong) id<DDHTimelineWindowControllerDelegate> delegate;
@property (strong) DDHImageLoader *imageLoader;
@property (strong) DDHAPIClient *apiClient;
@property (strong) NSString *hashtag;
@end

@implementation DDHTimelineWindowController

- (instancetype)initWithDelegate:(id<DDHTimelineWindowControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {
  return [self initWithDelegate:delegate hashtag:nil imageLoader:imageLoader apiClient:apiClient];
}

- (instancetype)initWithDelegate:(id<DDHTimelineWindowControllerDelegate>)delegate hashtag:(NSString *)hashtag imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {

  DDHTimelineViewController *timeLineViewController = [[DDHTimelineViewController alloc] initWithDelegate:self hashtag:hashtag imageLoader:imageLoader apiClient:apiClient];
  if (hashtag) {
    timeLineViewController.title = [NSString stringWithFormat:@"#%@", hashtag];
  } else {
    timeLineViewController.title = @"Home";
  }

  NSWindow *window = [NSWindow windowWithContentViewController:timeLineViewController];
  if (self = [super initWithWindow:window]) {
    _delegate = delegate;
    _imageLoader = imageLoader;
    _apiClient = apiClient;
    _hashtag = hashtag;

    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:timeLineViewController.title];
    toolbar.delegate = self;
    [toolbar insertItemWithItemIdentifier:reloadIdentifier atIndex:0];
    [toolbar insertItemWithItemIdentifier:composeIdentifier atIndex:1];

    window.toolbar = toolbar;
  }
  return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

// MARK: - Actions
- (void)reloadTimeline:(id)sender {
  DDHTimelineViewController *timelineViewController = (DDHTimelineViewController *)self.contentViewController;
  [self startSpinner];
  __weak typeof(self) weakSelf = self;
  [timelineViewController loadToots:sender withCompletionHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf stopSpinner];
    });
  }];
}

- (void)compose:(NSToolbarItem *)sender {
  DDHTimelineViewController *timelineViewController = (DDHTimelineViewController *)self.contentViewController;
  [timelineViewController openTootInputReplyingToToot:nil];
}

// MARK: - Spinner
- (void)startSpinner {
  if (NO == [self.window.toolbar.itemIdentifiers containsObject:spinnerIdentifier]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.window.toolbar insertItemWithItemIdentifier:spinnerIdentifier atIndex:0];
    });
  }
}

- (void)stopSpinner {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([self.window.toolbar.itemIdentifiers containsObject:spinnerIdentifier]) {
      [self.window.toolbar removeItemAtIndex:0];
    }
  });
}

// MARK: - NSToolbarDelegate
- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  return @[reloadIdentifier, composeIdentifier];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  return @[reloadIdentifier, composeIdentifier];
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
  } else if ([itemIdentifier isEqualToString:composeIdentifier]) {
    NSToolbarItem *composeItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    composeItem.image = [NSImage imageWithSystemSymbolName:@"square.and.pencil" accessibilityDescription:@"compose"];
    composeItem.target = self;
    composeItem.action = @selector(compose:);
    toolBarItem = composeItem;
  } else {
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolBarItem = item;
  }
  return toolBarItem;
}

// MARK: - DDHTimelineViewControllerDelegate
- (void)viewController:(NSViewController *)viewController didClickItem:(id)item {
  [self.delegate windowController:self didClickItem:item];
}

- (void)viewControllerStartedLoading:(NSViewController *)viewController {
  [self startSpinner];
}

- (void)viewControllerStoppedLoading:(NSViewController *)viewController {
  [self stopSpinner];
}

@end
