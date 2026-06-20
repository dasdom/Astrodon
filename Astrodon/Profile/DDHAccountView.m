//  Created by Dominik Hauser on 22.03.26.
//  
//


#import "DDHAccountView.h"
#import "DDHAccount.h"
#import "DDHAccountHeaderView.h"
#import "DDHAccountTextInfoView.h"

@interface DDHAccountView ()
@property (strong) DDHAccountHeaderView *headerView;
@property (strong) DDHAccountTextInfoView *textInfoView;
@end

@implementation DDHAccountView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {

    _headerView = [[DDHAccountHeaderView alloc] init];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;

    _textInfoView = [[DDHAccountTextInfoView alloc] init];
    _textInfoView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_headerView];
    [self addSubview:_textInfoView];

    [NSLayoutConstraint activateConstraints:@[
      [_headerView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_textInfoView.topAnchor constraintEqualToAnchor:_headerView.bottomAnchor constant:20],
      [_textInfoView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_textInfoView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}

- (void)updateWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader {
  [self.headerView updateWithAccount:account imageLoader:imageLoader];
  [self.textInfoView updateWithAccount:account];
}

@end
