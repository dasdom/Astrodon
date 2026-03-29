//  Created by Dominik Hauser on 22.03.26.
//  
//


#import "DDHAccountView.h"
#import "DDHAccount.h"
#import "DDHImageLoader.h"

@interface DDHAccountView ()
@property (strong) NSImageView *headerImageView;
@property (strong) NSImageView *avatarImageView;
@property (strong) NSLayoutConstraint *headerAspectRationConstraint;
@end

@implementation DDHAccountView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _headerImageView = [[NSImageView alloc] init];
    _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerImageView.imageAlignment = NSImageAlignTop;
    _headerImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    _headerImageView.hidden = YES;

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
//    _avatarImageView.layer.borderColor = [NSColor whiteColor].CGColor;
//    _avatarImageView.layer.borderWidth = 2;
    _avatarImageView.clipsToBounds = YES;
    [avatarHostView addSubview:_avatarImageView];

//    NSView *headerOverlay = [[NSView alloc] init];
//    headerOverlay.translatesAutoresizingMaskIntoConstraints = NO;
//    headerOverlay.wantsLayer = YES;
//    headerOverlay.layer.backgroundColor = [[NSColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
//    [_headerImageView addSubview:headerOverlay];

    [self addSubview:_headerImageView];
    [self addSubview:avatarHostView];

    [_headerImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [_headerImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

    _headerAspectRationConstraint = [_headerImageView.heightAnchor constraintEqualToAnchor:_headerImageView.widthAnchor multiplier:0.2];

    [NSLayoutConstraint activateConstraints:@[
      [_headerImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_headerImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_headerImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      _headerAspectRationConstraint,

//      [headerOverlay.topAnchor constraintEqualToAnchor:avatarHostView.centerYAnchor],
//      [headerOverlay.leadingAnchor constraintEqualToAnchor:_headerImageView.leadingAnchor],
//      [headerOverlay.bottomAnchor constraintEqualToAnchor:_headerImageView.bottomAnchor],
//      [headerOverlay.trailingAnchor constraintEqualToAnchor:_headerImageView.trailingAnchor],

      [avatarHostView.topAnchor constraintEqualToAnchor:self.topAnchor constant:50],
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
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
      NSLog(@"size: %@, ratio: %lf", [NSValue valueWithSize:image.size], image.size.width / image.size.height);

      weakSelf.headerImageView.hidden = NO;

      weakSelf.headerAspectRationConstraint.active = NO;

      weakSelf.headerAspectRationConstraint = [weakSelf.headerImageView.heightAnchor constraintEqualToAnchor:weakSelf.headerImageView.widthAnchor multiplier:image.size.height / image.size.width];
//
      weakSelf.headerAspectRationConstraint.active = YES;

      weakSelf.headerImageView.image = image;
    });
  }];
}

@end
