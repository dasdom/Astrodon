//  Created by Dominik Hauser on 22.03.26.
//  
//


#import "DDHAccountView.h"
#import "DDHAccount.h"
#import "DDHImageLoader.h"
#import "DDHImageView.h"

@interface DDHAccountView ()
@property (strong) DDHImageView *headerImageView;
@property (strong) NSImageView *avatarImageView;
@property (strong) NSTextField *displayNameLabel;
@property (strong) NSTextField *accountNameLabel;
@property (strong) NSTextField *noteLabel;
@end

@implementation DDHAccountView

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

    _displayNameLabel = [NSTextField labelWithString:@""];
    _displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _displayNameLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleHeadline options:@{}];

    _accountNameLabel = [NSTextField labelWithString:@""];
    _accountNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _accountNameLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleCallout options:@{}];
    _accountNameLabel.textColor = [NSColor secondaryLabelColor];

    _noteLabel = [NSTextField wrappingLabelWithString:@""];
    _noteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _noteLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}];
    [_noteLabel setContentCompressionResistancePriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [_noteLabel setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [_noteLabel setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];


    [self addSubview:_headerImageView];
    [self addSubview:avatarHostView];
    [self addSubview:_displayNameLabel];
    [self addSubview:_accountNameLabel];
    [self addSubview:_noteLabel];

    [_headerImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [_headerImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

    [NSLayoutConstraint activateConstraints:@[
      [_headerImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_headerImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_headerImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [_headerImageView.heightAnchor constraintEqualToConstant:150],

      [avatarHostView.topAnchor constraintEqualToAnchor:self.topAnchor constant:80],
      [avatarHostView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [avatarHostView.widthAnchor constraintEqualToConstant:100],
      [avatarHostView.heightAnchor constraintEqualToAnchor:avatarHostView.widthAnchor],

      [_avatarImageView.topAnchor constraintEqualToAnchor:avatarHostView.topAnchor],
      [_avatarImageView.leadingAnchor constraintEqualToAnchor:avatarHostView.leadingAnchor],
      [_avatarImageView.bottomAnchor constraintEqualToAnchor:avatarHostView.bottomAnchor],
      [_avatarImageView.trailingAnchor constraintEqualToAnchor:avatarHostView.trailingAnchor],

      [_displayNameLabel.topAnchor constraintEqualToAnchor:avatarHostView.bottomAnchor constant:20],
      [_displayNameLabel.centerXAnchor constraintEqualToAnchor:avatarHostView.centerXAnchor],

      [_accountNameLabel.topAnchor constraintEqualToAnchor:_displayNameLabel.bottomAnchor constant:8],
      [_accountNameLabel.centerXAnchor constraintEqualToAnchor:_displayNameLabel.centerXAnchor],

      [_noteLabel.topAnchor constraintEqualToAnchor:_accountNameLabel.bottomAnchor constant:30],
      [_noteLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
      [_noteLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
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

  self.displayNameLabel.stringValue = account.displayName;
  self.accountNameLabel.stringValue = account.acct;

  NSString *trimmedContent = [account.note stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSData *contentData = [trimmedContent dataUsingEncoding:NSUTF16StringEncoding];

  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithHTML:contentData documentAttributes:nil];
  [attributedString addAttributes:@{NSFontAttributeName: [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}]}
                            range:NSMakeRange(0, attributedString.length)];
  self.noteLabel.attributedStringValue = attributedString;
}

@end
