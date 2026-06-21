//  Created by Dominik Hauser on 26.12.25.
//  
//


#import "DDHTimelineView.h"

@interface DDHTimelineView ()
@property (nonatomic, strong) NSProgressIndicator *topProgressIndicator;
@property (nonatomic, strong) NSView *topProgressIndicatorHostView;
@property (nonatomic, strong) NSProgressIndicator *bottomProgressIndicator;
@property (nonatomic, strong) NSView *bottomProgressIndicatorHostView;
@end

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

    _topProgressIndicator = [[NSProgressIndicator alloc] init];
    _topProgressIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    _topProgressIndicator.style = NSProgressIndicatorStyleSpinning;
    _topProgressIndicator.controlSize = NSControlSizeSmall;

    _topProgressIndicatorHostView = [[NSView alloc] init];
    _topProgressIndicatorHostView.translatesAutoresizingMaskIntoConstraints = NO;
    _topProgressIndicatorHostView.hidden = YES;
    [_topProgressIndicatorHostView addSubview:_topProgressIndicator];

    _bottomProgressIndicator = [[NSProgressIndicator alloc] init];
    _bottomProgressIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomProgressIndicator.style = NSProgressIndicatorStyleSpinning;
    _bottomProgressIndicator.controlSize = NSControlSizeSmall;

    _bottomProgressIndicatorHostView = [[NSView alloc] init];
    _bottomProgressIndicatorHostView.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomProgressIndicatorHostView.hidden = YES;
    [_bottomProgressIndicatorHostView addSubview:_bottomProgressIndicator];

    [self addSubview:_scrollView];
    [self addSubview:_topProgressIndicatorHostView];
    [self addSubview:_bottomProgressIndicatorHostView];

    [NSLayoutConstraint activateConstraints:@[
      [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_topProgressIndicatorHostView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_topProgressIndicatorHostView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_topProgressIndicatorHostView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_topProgressIndicator.topAnchor constraintEqualToAnchor:_topProgressIndicatorHostView.topAnchor],
      [_topProgressIndicator.bottomAnchor constraintEqualToAnchor:_topProgressIndicatorHostView.bottomAnchor],
      [_topProgressIndicator.centerXAnchor constraintEqualToAnchor:_topProgressIndicatorHostView.centerXAnchor],

      [_bottomProgressIndicatorHostView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_bottomProgressIndicatorHostView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_bottomProgressIndicatorHostView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_bottomProgressIndicator.topAnchor constraintEqualToAnchor:_bottomProgressIndicatorHostView.topAnchor],
      [_bottomProgressIndicator.bottomAnchor constraintEqualToAnchor:_bottomProgressIndicatorHostView.bottomAnchor],
      [_bottomProgressIndicator.centerXAnchor constraintEqualToAnchor:_bottomProgressIndicatorHostView.centerXAnchor],
    ]];
  }
  return self;
}

- (void)startTopSpinner {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.topProgressIndicatorHostView.hidden = NO;
    [self.topProgressIndicator startAnimation:self];
  });
}

- (void)stopTopSpinner {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.topProgressIndicatorHostView.hidden = YES;
    [self.topProgressIndicator stopAnimation:self];
  });
}

- (void)startBottomSpinner {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.bottomProgressIndicatorHostView.hidden = NO;
    [self.bottomProgressIndicator startAnimation:self];
  });
}

- (void)stopBottomSpinner {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.bottomProgressIndicatorHostView.hidden = YES;
    [self.bottomProgressIndicator stopAnimation:self];
  });
}

@end
