//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHTootInputView.h"
#import "DDHTootView.h"

@interface DDHTootInputView ()
@property (strong) NSScrollView *scrollView;
@end

@implementation DDHTootInputView

- (instancetype)initWithFrame:(NSRect)frameRect showToot:(BOOL)showToot {
  if (self = [super initWithFrame:frameRect]) {

    if (showToot) {
      _tootView = [[DDHTootView alloc] init];
      _tootView.translatesAutoresizingMaskIntoConstraints = NO;
      _tootView.wantsLayer = YES;
      _tootView.layer.backgroundColor = [NSColor colorWithWhite:0.05 alpha:1].CGColor;

      _scrollView = [[NSScrollView alloc] init];
      _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
      _scrollView.documentView = _tootView;
      [self addSubview:_scrollView];
    }

    _inputTextView = [[NSTextView alloc] init];
    _inputTextView.translatesAutoresizingMaskIntoConstraints = NO;

    _sendButton = [NSButton buttonWithTitle:@"Send" target:nil action:nil];
    _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_sendButton setButtonType:NSButtonTypeMomentaryPushIn];

    _progressIndicator = [[NSProgressIndicator alloc] init];
    _progressIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    _progressIndicator.hidden = YES;

    [self addSubview:_inputTextView];
    [self addSubview:_sendButton];
    [self addSubview:_progressIndicator];

    NSMutableArray<NSLayoutConstraint *> *layoutConstraints = [[NSMutableArray alloc] initWithArray:@[
      [_inputTextView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
      [_inputTextView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
      
      [_sendButton.topAnchor constraintEqualToAnchor:_inputTextView.bottomAnchor constant:4],
      [_sendButton.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
      [_sendButton.trailingAnchor constraintEqualToAnchor:_inputTextView.trailingAnchor],
      
      [_progressIndicator.centerYAnchor constraintEqualToAnchor:_sendButton.centerYAnchor],
      [_progressIndicator.trailingAnchor constraintEqualToAnchor:_sendButton.leadingAnchor constant:-8],
    ]];

    if (_scrollView) {
      [layoutConstraints addObjectsFromArray:@[
        [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_scrollView.heightAnchor constraintEqualToConstant:200],

        [_tootView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor],

        [_inputTextView.topAnchor constraintEqualToAnchor:_scrollView.bottomAnchor constant:10],
      ]];
    } else {
      [layoutConstraints addObject:[_inputTextView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor]];
    }

    [NSLayoutConstraint activateConstraints:layoutConstraints];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];

  
}

- (void)scrollUp {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // Scroll the vertical scroller to top
    if ([self.scrollView hasVerticalScroller]) {
      self.scrollView.verticalScroller.floatValue = 0;
    }
    // Scroll the contentView to top
    [self.scrollView.contentView scrollToPoint:NSMakePoint(0, ((NSView*)self.scrollView.documentView).frame.size.height - self.scrollView.contentSize.height)];
  });
}

@end
