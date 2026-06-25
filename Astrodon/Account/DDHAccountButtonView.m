//  Created by Dominik Hauser on 22.06.26.
//  
//


#import "DDHAccountButtonView.h"

@implementation DDHAccountButtonView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _followButton = [[NSButton alloc] init];
    _followButton.translatesAutoresizingMaskIntoConstraints = NO;
    _followButton.title = @"Follow";
    _followButton.enabled = NO;

    [self addSubview:_followButton];

    [NSLayoutConstraint activateConstraints:@[
      [_followButton.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_followButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_followButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_followButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}

@end
