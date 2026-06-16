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
//    _tableView.usesAlternatingRowBackgroundColors = YES;
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;

    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"Column"];
    column.title = @"Toots";
    column.minWidth = 300;
    column.maxWidth = 1000;
    column.resizingMask = NSTableColumnAutoresizingMask;
    [_tableView addTableColumn:column];

    _scrollView = [[NSScrollView alloc] initWithFrame:frameRect];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.documentView = _tableView;
    _scrollView.hasVerticalScroller = YES;

    [self addSubview:_scrollView];

    [NSLayoutConstraint activateConstraints:@[
      [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}

@end
