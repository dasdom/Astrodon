//  Created by Dominik Hauser on 20.06.26.
//  
//


#import "DDHAccountHeaderView.h"
#import "DDHAccount.h"
#import "DDHImageLoader.h"
#import "DDHImageView.h"

@interface DDHAccountHeaderView ()
@property (strong) DDHImageView *headerImageView;
@property (strong) NSImageView *avatarImageView;
@end

@implementation DDHAccountHeaderView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _headerImageView = [[DDHImageView alloc] init];
    _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerImageView.hidden = YES;
    _headerImageView.clipsToBounds = YES;

    NSView *avatarHostView = [[NSView alloc] init];
    avatarHostView.translatesAutoresizingMaskIntoConstraints = NO;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [NSColor blackColor];
    shadow.shadowOffset = CGSizeMake(4, -4);
    shadow.shadowBlurRadius = 4;
    avatarHostView.shadow = shadow;

    _avatarImageView = [[NSImageView alloc] init];
    _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _avatarImageView.wantsLayer = YES;
    _avatarImageView.layer.cornerRadius = 10;
    _avatarImageView.clipsToBounds = YES;
    [avatarHostView addSubview:_avatarImageView];

    [self addSubview:_headerImageView];
    [self addSubview:avatarHostView];

    [_headerImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [_headerImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

    [NSLayoutConstraint activateConstraints:@[
      [_headerImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_headerImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_headerImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [_headerImageView.heightAnchor constraintEqualToConstant:150],

      [avatarHostView.topAnchor constraintEqualToAnchor:self.topAnchor constant:80],
      [avatarHostView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [avatarHostView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [avatarHostView.widthAnchor constraintEqualToConstant:100],
      [avatarHostView.heightAnchor constraintEqualToAnchor:avatarHostView.widthAnchor],

      [_avatarImageView.topAnchor constraintEqualToAnchor:avatarHostView.topAnchor],
      [_avatarImageView.leadingAnchor constraintEqualToAnchor:avatarHostView.leadingAnchor],
      [_avatarImageView.bottomAnchor constraintEqualToAnchor:avatarHostView.bottomAnchor],
      [_avatarImageView.trailingAnchor constraintEqualToAnchor:avatarHostView.trailingAnchor],
    ]];
  }

  return self;
}

- (void)updateWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader {
  __weak typeof(self)weakSelf = self;
  [imageLoader loadImageForURL:account.avatarURL completionHandler:^(NSImage *image) {
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.avatarImageView.image = image;
    });
  }];

  self.headerImageView.hidden = YES;

  [imageLoader loadImageForURL:account.headerURL completionHandler:^(NSImage *image) {
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.headerImageView.hidden = NO;
      weakSelf.headerImageView.image = image;
    });
  }];
}

@end
