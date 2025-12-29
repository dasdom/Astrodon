//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHTootInputView.h"

@interface DDHTootInputView ()
@end

@implementation DDHTootInputView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
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

    [NSLayoutConstraint activateConstraints:@[
      [_inputTextView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
      [_inputTextView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
      [_inputTextView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],

      [_sendButton.topAnchor constraintEqualToAnchor:_inputTextView.bottomAnchor constant:4],
      [_sendButton.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
      [_sendButton.trailingAnchor constraintEqualToAnchor:_inputTextView.trailingAnchor],

      [_progressIndicator.centerYAnchor constraintEqualToAnchor:_sendButton.centerYAnchor],
      [_progressIndicator.trailingAnchor constraintEqualToAnchor:_sendButton.leadingAnchor constant:-8],
    ]];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];

  
}

@end
