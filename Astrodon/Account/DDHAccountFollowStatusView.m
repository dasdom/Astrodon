//  Created by Dominik Hauser on 22.06.26.
//  
//


#import "DDHAccountFollowStatusView.h"
#import "DDHAccount.h"
#import "DDHRelationship.h"

@interface DDHAccountFollowStatusView ()
@property (strong) NSTextField *youFollow;
@property (strong) NSTextField *theyFollow;
@end

@implementation DDHAccountFollowStatusView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _youFollow = [NSTextField labelWithString:@""];
    _youFollow.translatesAutoresizingMaskIntoConstraints = NO;
    _youFollow.font = [NSFont preferredFontForTextStyle:NSFontTextStyleCallout options:@{}];

    _theyFollow = [NSTextField labelWithString:@""];
    _theyFollow.translatesAutoresizingMaskIntoConstraints = NO;
    _theyFollow.font = [NSFont preferredFontForTextStyle:NSFontTextStyleCallout options:@{}];

    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithWhite:0.1 alpha:0.7].CGColor;

    [self addSubview:_youFollow];
    [self addSubview:_theyFollow];

    [NSLayoutConstraint activateConstraints:@[
      [_youFollow.topAnchor constraintEqualToAnchor:self.topAnchor constant:2],
      [_youFollow.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
      [_youFollow.bottomAnchor constraintEqualToAnchor:_theyFollow.topAnchor],
      [_youFollow.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],

      [_theyFollow.leadingAnchor constraintEqualToAnchor:_youFollow.leadingAnchor],
      [_theyFollow.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-2],
      [_theyFollow.trailingAnchor constraintEqualToAnchor:_youFollow.trailingAnchor],
    ]];
  }
  return self;
}

- (void)updateWithAccount:(DDHAccount *)account relationship:(DDHRelationship *)relationship {
  if (relationship.following) {
    self.youFollow.stringValue = [NSString stringWithFormat:@"You follow %@", account.username];
  } else {
    self.youFollow.stringValue = @"";
  }

  if (relationship.followedBy) {
    self.theyFollow.stringValue = [NSString stringWithFormat:@"%@ follows you", account.username];
  } else {
    self.theyFollow.stringValue = @"";
  }
}

@end
