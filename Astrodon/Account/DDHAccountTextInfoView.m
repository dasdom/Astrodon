//  Created by Dominik Hauser on 20.06.26.
//  
//


#import "DDHAccountTextInfoView.h"
#import "DDHAccount.h"

@interface DDHAccountTextInfoView ()
@property (strong) NSTextField *displayNameLabel;
@property (strong) NSTextField *accountNameLabel;
@property (strong) NSTextField *noteLabel;
@end

@implementation DDHAccountTextInfoView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _displayNameLabel = [NSTextField labelWithString:@""];
    _displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _displayNameLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleHeadline options:@{}];

    _accountNameLabel = [NSTextField labelWithString:@""];
    _accountNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _accountNameLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleCallout options:@{}];
    _accountNameLabel.textColor = [NSColor secondaryLabelColor];

    _noteLabel = [NSTextField wrappingLabelWithString:@""];
    _noteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _noteLabel.selectable = NO;
    _noteLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}];
    [_noteLabel setContentCompressionResistancePriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [_noteLabel setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [_noteLabel setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];

    [self addSubview:_displayNameLabel];
    [self addSubview:_accountNameLabel];
    [self addSubview:_noteLabel];

    [NSLayoutConstraint activateConstraints:@[

      [_displayNameLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_displayNameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],

      [_accountNameLabel.topAnchor constraintEqualToAnchor:_displayNameLabel.bottomAnchor constant:8],
      [_accountNameLabel.centerXAnchor constraintEqualToAnchor:_displayNameLabel.centerXAnchor],

      [_noteLabel.topAnchor constraintEqualToAnchor:_accountNameLabel.bottomAnchor constant:30],
      [_noteLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
      [_noteLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_noteLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
    ]];
  }
  return self;
}

- (void)updateWithAccount:(DDHAccount *)account {

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
