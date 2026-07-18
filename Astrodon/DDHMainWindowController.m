//  Created by Dominik Hauser on 05.07.26.
//
//


#import "DDHMainWindowController.h"
#import "DDHMainViewController.h"
#import "DDHTimelineViewController.h"

@interface DDHMainWindowController () <NSToolbarDelegate>
@property (strong) id<DDHMainWindowControllerDelegate> delegate;
@property (strong) DDHImageLoader *imageLoader;
@property (strong) DDHAPIClient *apiClient;
@end

//NSString * const reloadIdentifier = @"reloadIdentifier";
//NSString * const spinnerIdentifier = @"spinnerIdentifier";
//NSString * const composeIdentifier = @"composeIdentifier";
//NSString * const closeDetailsIdentifier = @"closeDetailsIdentifier";

@implementation DDHMainWindowController

- (instancetype)initWithDelegate:(id<DDHMainWindowControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {

  DDHMainViewController *viewController = [[DDHMainViewController alloc] initWithImageLoader:imageLoader apiClient:apiClient];

  NSWindow *window = [NSWindow windowWithContentViewController:viewController];

  if (self = [super initWithWindow:window]) {
    _delegate = delegate;
    _imageLoader = imageLoader;
    _apiClient = apiClient;

//    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"main_window_toolbar"];
//    toolbar.delegate = self;
//    [toolbar insertItemWithItemIdentifier:reloadIdentifier atIndex:0];
//    [toolbar insertItemWithItemIdentifier:composeIdentifier atIndex:1];
//    [toolbar insertItemWithItemIdentifier:closeDetailsIdentifier atIndex:2];
//
//    window.toolbar = toolbar;
  }

  return self;
}

- (void)windowDidLoad {
  [super windowDidLoad];

  
}

- (DDHTimelineViewController *)homeViewController {
  DDHMainViewController *mainViewController = (DDHMainViewController *)self.contentViewController;
  return [mainViewController homeViewController];
}

// MARK: - Actions
- (void)reloadTimeline:(id)sender {
  DDHTimelineViewController *timelineViewController = [self homeViewController];
//  [self startSpinner];
  __weak typeof(self) weakSelf = self;
  [timelineViewController loadToots:sender withCompletionHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
//      [weakSelf stopSpinner];
    });
  }];
}

- (void)compose:(NSToolbarItem *)sender {
  DDHTimelineViewController *timelineViewController = [self homeViewController];
  [timelineViewController openTootInputReplyingToToot:nil];
}

- (void)closeDetails:(NSToolbarItem *)sender {
  DDHMainViewController *mainViewController = (DDHMainViewController *)self.contentViewController;
  [mainViewController closeDetails];
}

//// MARK: - Spinner
//- (void)startSpinner {
//  if (NO == [self.window.toolbar.itemIdentifiers containsObject:spinnerIdentifier]) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [self.window.toolbar insertItemWithItemIdentifier:spinnerIdentifier atIndex:0];
//    });
//  }
//}
//
//- (void)stopSpinner {
//  dispatch_async(dispatch_get_main_queue(), ^{
//    if ([self.window.toolbar.itemIdentifiers containsObject:spinnerIdentifier]) {
//      [self.window.toolbar removeItemAtIndex:0];
//    }
//  });
//}

//// MARK: - NSToolbarDelegate
//- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
//  return @[reloadIdentifier, composeIdentifier, closeDetailsIdentifier];
//}
//
//- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
//  return @[reloadIdentifier, composeIdentifier, closeDetailsIdentifier];
//}
//
//- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
//
//  NSToolbarItem *toolBarItem;
//  if ([itemIdentifier isEqualToString:reloadIdentifier]) {
//    NSToolbarItem *reloadItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
//    reloadItem.image = [NSImage imageWithSystemSymbolName:@"arrow.clockwise" accessibilityDescription:@"reload"];
//    reloadItem.target = self;
//    reloadItem.action = @selector(reloadTimeline:);
//    toolBarItem = reloadItem;
//  } else if ([itemIdentifier isEqualToString:spinnerIdentifier]) {
//    NSToolbarItem *spinnerItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
//    NSProgressIndicator *progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
//    progressIndicator.style = NSProgressIndicatorStyleSpinning;
//    [progressIndicator startAnimation:nil];
//    spinnerItem.view = progressIndicator;
//    toolBarItem = spinnerItem;
//  } else if ([itemIdentifier isEqualToString:composeIdentifier]) {
//    NSToolbarItem *composeItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
//    composeItem.image = [NSImage imageWithSystemSymbolName:@"square.and.pencil" accessibilityDescription:@"compose"];
//    composeItem.target = self;
//    composeItem.action = @selector(compose:);
//    toolBarItem = composeItem;
//  } else if ([itemIdentifier isEqualToString:closeDetailsIdentifier]) {
//    NSToolbarItem *composeItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
//    composeItem.image = [NSImage imageWithSystemSymbolName:@"sidebar.squares.right" accessibilityDescription:@"close details"];
//    composeItem.target = self;
//    composeItem.action = @selector(closeDetails:);
//    toolBarItem = composeItem;
//  } else {
//    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
//    toolBarItem = item;
//  }
//  return toolBarItem;
//}

@end
