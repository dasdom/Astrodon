//  Created by Dominik Hauser on 26.12.25.
//  
//


#import "DDHTimelineView.h"

@implementation DDHTimelineView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _tableView = [[NSTableView alloc] initWithFrame:frameRect];
    _tableView.rowHeight = 120;
    _tableView.style = NSTableViewStyleFullWidth;
    _tableView.columnAutoresizingStyle = NSTableViewLastColumnOnlyAutoresizingStyle;
    _tableView.allowsColumnResizing = YES;
    _tableView.headerView = nil;
    _tableView.usesAlternatingRowBackgroundColors = YES;
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;

    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"Column"];
    column.title = @"Toots";
    column.minWidth = 40;
    column.maxWidth = 1000;
    column.resizingMask = NSTableColumnAutoresizingMask;
    [_tableView addTableColumn:column];

    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:frameRect];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.documentView = _tableView;
    scrollView.hasVerticalScroller = YES;

    [self addSubview:scrollView];

    [NSLayoutConstraint activateConstraints:@[
      [scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
