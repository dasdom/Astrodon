//  Created by Dominik Hauser on 22.03.26.
//  
//


#import "DDHAccountView.h"
#import "DDHAccount.h"
#import "DDHAccountHeaderView.h"
#import "DDHAccountTextInfoView.h"
#import "DDHAccountFollowStatusView.h"
#import "DDHAccountButtonView.h"
#import "DDHRelationship.h"

@interface DDHAccountView ()
@property (strong) DDHAccountHeaderView *headerView;
@property (strong) DDHAccountFollowStatusView *followStatusView;
@property (strong) DDHAccountTextInfoView *textInfoView;
@property (strong) DDHAccountButtonView *buttonView;
@end

@implementation DDHAccountView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {

    _headerView = [[DDHAccountHeaderView alloc] init];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;

    _followStatusView = [[DDHAccountFollowStatusView alloc] init];
    _followStatusView.translatesAutoresizingMaskIntoConstraints = NO;

    _textInfoView = [[DDHAccountTextInfoView alloc] init];
    _textInfoView.translatesAutoresizingMaskIntoConstraints = NO;

    _buttonView = [[DDHAccountButtonView alloc] init];
    _buttonView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_headerView];
    [self addSubview:_followStatusView];
    [self addSubview:_textInfoView];
    [self addSubview:_buttonView];

    [NSLayoutConstraint activateConstraints:@[
      [_headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_textInfoView.topAnchor constraintEqualToAnchor:_headerView.bottomAnchor constant:20],
      [_textInfoView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_textInfoView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_followStatusView.leadingAnchor constraintEqualToAnchor:[_headerView anchorView].leadingAnchor],
      [_followStatusView.topAnchor constraintEqualToAnchor:[_headerView anchorView].bottomAnchor],

      [_buttonView.topAnchor constraintEqualToAnchor:_textInfoView.bottomAnchor],
      [_buttonView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
      [_buttonView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
    ]];
  }
  return self;
}

- (void)updateWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader {
  [self.headerView updateWithAccount:account imageLoader:imageLoader];
  [self.textInfoView updateWithAccount:account];
}

- (void)updateWithAccount:(DDHAccount *)account relationship:(DDHRelationship *)relationship {
  [self.followStatusView updateWithAccount:account relationship:relationship];

  [self updateFollowButtonForFollowing:relationship.following];
}

- (void)updateFollowButtonForFollowing:(BOOL)following {
  NSButton *followButton = self.buttonView.followButton;

  followButton.enabled = YES;

  if (following) {
    followButton.title = @"Unfollow";
  } else {
    followButton.title = @"Follow";
  }
}

- (NSButton *)followButton {
  return self.buttonView.followButton;
}

@end
