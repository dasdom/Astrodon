//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHTimelineWindowController.h"
#import "DDHTimelineViewController.h"

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
    [toolbar insertItemWithItemIdentifier:@"reload_toolbar_item" atIndex:0];

    window.toolbar = toolbar;
  }
  return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (void)reloadTimeline:(id)sender {
  DDHTimelineViewController *timelineViewController = (DDHTimelineViewController *)self.contentViewController;
  [timelineViewController loadToots:sender];
}

// MARK: - NSToolbarDelegate
- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"reload_toolbar_item"];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
  return @[@"reload_toolbar_item"];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {

  NSToolbarItem *reloadItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"reload_toolbar_item"];
  reloadItem.image = [NSImage imageWithSystemSymbolName:@"arrow.clockwise" accessibilityDescription:@"reload"];
  reloadItem.target = self;
  reloadItem.action = @selector(reloadTimeline:);
  return reloadItem;
}

@end
