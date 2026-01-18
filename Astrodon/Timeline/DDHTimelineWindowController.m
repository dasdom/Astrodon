//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHTimelineWindowController.h"
#import "DDHTimelineViewController.h"

NSString * const reloadIdentifier = @"reloadIdentifier";
NSString * const spinnerIdentifier = @"spinnerIdentifier";

@interface DDHTimelineWindowController () <NSToolbarDelegate>

@end

@implementation DDHTimelineWindowController

- (instancetype)init {
  DDHTimelineViewController *timeLineViewController = [DDHTimelineViewController new];
  timeLineViewController.title = @"Timeline";

  NSWindow *window = [NSWindow windowWithContentViewController:timeLineViewController];
  if (self = [super initWithWindow:window]) {
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

@end
