//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineCellView.h"
#import "DDHToot.h"
#import "DDHImageLoader.h"
#import "DDHAccount.h"
#import "DDHMediaAttachment.h"

@interface DDHTimelineCellView ()
@property (nonatomic, strong) NSImageView *avatarImageView;
@property (nonatomic, strong) NSImageView *boostersImageView;
@property (nonatomic, strong) NSTextField *displayNameTextField;
@property (nonatomic, strong) NSTextField *acctTextField;
@property (nonatomic, strong) NSTextField *tootTextField;
@property (nonatomic, strong) NSLayoutConstraint *avatarImageWidthConstraint;
@property (nonatomic, strong) NSButton *showMoreButton;
@property (nonatomic, strong) NSImageView *attachmentImageView;
@property (nonatomic, strong) NSLayoutConstraint *aspectConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *attachmentBottomConstraint;
@end

@implementation DDHTimelineCellView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _avatarImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView = _avatarImageView;

    _boostersImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _boostersImageView.translatesAutoresizingMaskIntoConstraints = NO;

    _displayNameTextField = [NSTextField labelWithString:@"displayName"];
    _displayNameTextField.translatesAutoresizingMaskIntoConstraints = NO;

    _acctTextField = [NSTextField labelWithString:@"acct"];
    _acctTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _acctTextField.font = [NSFont preferredFontForTextStyle:NSFontTextStyleFootnote options:@{}];
    _acctTextField.textColor = [NSColor secondaryLabelColor];

    _tootTextField = [NSTextField wrappingLabelWithString:@"toot text"];
    _tootTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _tootTextField.selectable = NO;
    [_tootTextField setContentCompressionResistancePriority:NSLayoutPriorityRequired forOrientation:NSUserInterfaceLayoutOrientationVertical];
    self.textField = _tootTextField;

    _showMoreButton = [NSButton buttonWithTitle:@"show more" target:nil action:nil];

    _attachmentImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 0)];
    _attachmentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _attachmentImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [_attachmentImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [_attachmentImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

    [self addSubview:_avatarImageView];
    [self addSubview:_boostersImageView];
    [self addSubview:_displayNameTextField];
    [self addSubview:_acctTextField];
    [self addSubview:_tootTextField];
    [self addSubview:_attachmentImageView];

    _avatarImageWidthConstraint = [_avatarImageView.widthAnchor constraintEqualToConstant:60];
    _textBottomConstraint = [_tootTextField.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor];
    _attachmentBottomConstraint = [_attachmentImageView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor];

    [NSLayoutConstraint activateConstraints:@[
      [_avatarImageView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
      [_avatarImageView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
      _avatarImageWidthConstraint,
      [_avatarImageView.heightAnchor constraintEqualToAnchor:_avatarImageView.widthAnchor],

      [_boostersImageView.centerXAnchor constraintEqualToAnchor:_avatarImageView.trailingAnchor],
      [_boostersImageView.centerYAnchor constraintEqualToAnchor:_avatarImageView.bottomAnchor],
      [_boostersImageView.widthAnchor constraintEqualToConstant:30],
      [_boostersImageView.heightAnchor constraintEqualToAnchor:_boostersImageView.widthAnchor],

      [_displayNameTextField.topAnchor constraintEqualToAnchor:_avatarImageView.topAnchor],
      [_displayNameTextField.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:70],

      [_acctTextField.topAnchor constraintEqualToAnchor:_displayNameTextField.bottomAnchor],
      [_acctTextField.leadingAnchor constraintEqualToAnchor:_displayNameTextField.leadingAnchor],

      [_tootTextField.topAnchor constraintEqualToAnchor:_acctTextField.bottomAnchor constant:10],
      [_tootTextField.leadingAnchor constraintEqualToAnchor:_acctTextField.leadingAnchor],
      _textBottomConstraint,
      [_tootTextField.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],

      [_attachmentImageView.topAnchor constraintEqualToAnchor:_tootTextField.bottomAnchor constant:8],
      [_attachmentImageView.leadingAnchor constraintEqualToAnchor:_tootTextField.leadingAnchor],
      [_attachmentImageView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
    ]];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {

  [self setImagesForToot:toot imageLoader:imageLoader];
  [self setTextForToot:toot];
  [self setAttachmentsForToot:toot imageLoader:imageLoader];
}

// MARK: - Helper
- (void)setTextForToot:(DDHToot *)toot {
  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;

  NSData *contentData = [tootToShow.content dataUsingEncoding:NSUTF16StringEncoding];
  DDHAccount *account = tootToShow.account;

  self.displayNameTextField.stringValue = account.displayName;
  self.acctTextField.stringValue = account.acct;

  if (tootToShow.sensitive && !tootToShow.showsSensitive) {
    self.textField.stringValue = tootToShow.spoilerText;

    self.showMoreButton.hidden = NO;
  } else {
    if (tootToShow.showsSensitive) {
      self.showMoreButton.hidden = NO;
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithHTML:contentData documentAttributes:nil];
    [attributedString addAttributes:@{NSFontAttributeName: [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}]}
                              range:NSMakeRange(0, attributedString.length)];
    self.textField.attributedStringValue = attributedString;

    self.showMoreButton.hidden = YES;
  }
}

- (void)setImagesForToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {
  if ([toot isBoost]) {
    [imageLoader loadImageForURL:toot.boostedToot.account.avatarURL completionHandler:^(NSImage *image) {
      if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.imageView.image = image;
        });
      }
    }];
    [imageLoader loadImageForURL:toot.account.avatarURL completionHandler:^(NSImage *image) {
      if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.boostersImageView.image = image;
        });
      }
    }];
    self.boostersImageView.hidden = NO;
    self.avatarImageWidthConstraint.constant = 45;
  } else {
    [imageLoader loadImageForURL:toot.account.avatarURL completionHandler:^(NSImage *image) {
      if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.imageView.image = image;
        });
      }
    }];
    self.boostersImageView.hidden = YES;
    self.avatarImageWidthConstraint.constant = 60;
  }
}

- (void)setAttachmentsForToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {
  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;
  self.attachmentImageView.hidden = YES;
  self.textBottomConstraint.active = YES;
  self.aspectConstraint.active = NO;
  [tootToShow.mediaAttachments enumerateObjectsUsingBlock:^(DDHMediaAttachment * _Nonnull mediaAttachment, NSUInteger idx, BOOL * _Nonnull stop) {
    switch (mediaAttachment.type) {
      case DDHAttachmentTypeUnknown:
        break;
      case DDHAttachmentTypeImage:
        self.attachmentImageView.hidden = NO;
        self.aspectConstraint.active = NO;
        self.textBottomConstraint.active = NO;
        self.attachmentBottomConstraint.active = YES;
        self.aspectConstraint = [self.attachmentImageView.widthAnchor constraintEqualToAnchor:self.attachmentImageView.heightAnchor multiplier:mediaAttachment.smallDimensions.aspect];
        self.aspectConstraint.priority = 750;
        self.aspectConstraint.active = YES;
        [imageLoader loadImageForURL:mediaAttachment.previewURL completionHandler:^(NSImage *image) {
          dispatch_async(dispatch_get_main_queue(), ^{
            self.attachmentImageView.image = image;
          });
        }];
        break;
    }
  }];
}

- (void)mouseDown:(NSEvent *)event {
  NSLog(@"event: %@", event);

  NSAttributedString *attributedString = [self.tootTextField.attributedStringValue copy];
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.tootTextField.bounds.size];

  textContainer.lineFragmentPadding = 0;
  textContainer.maximumNumberOfLines = self.tootTextField.maximumNumberOfLines;
  textContainer.lineBreakMode = self.tootTextField.lineBreakMode;

  [layoutManager addTextContainer:textContainer];
  [textStorage addLayoutManager:layoutManager];

  NSPoint pointInWindow = [event locationInWindow];
  NSPoint convertedPoint = [self.tootTextField convertPoint:pointInWindow fromView:nil];
  NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:convertedPoint inTextContainer:textContainer];
  NSUInteger characterIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];

  [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    if (NSLocationInRange(characterIndex, range)) {
      NSLog(@"range: %@", [NSValue valueWithRange:range]);
      NSLog(@"attrs: %@", attrs);
    }
  }];
}

@end
