//  Created by Dominik Hauser on 16.01.26.
//  
//


#import "DDHTootView.h"
#import "DDHImageLoader.h"
#import "DDHToot.h"
#import "DDHAccount.h"
#import "DDHMediaAttachment.h"

@interface DDHTootView ()
@property (strong) NSImageView *imageView;
@property (strong) NSTextField *textField;
@property (strong) NSImageView *avatarImageView;
@property (strong) NSImageView *boostersImageView;
@property (strong) NSTextField *displayNameTextField;
@property (strong) NSTextField *dateTextField;
@property (strong) NSTextField *acctTextField;
@property (strong) NSTextField *tootTextField;
@property (strong) NSLayoutConstraint *avatarImageWidthConstraint;
@property (strong) NSButton *showMoreButton;
@property (strong) NSImageView *attachmentImageView;
@property (strong) NSLayoutConstraint *aspectConstraint;
@property (strong) NSLayoutConstraint *textBottomConstraint;
@property (strong) NSLayoutConstraint *attachmentBottomConstraint;
@end

@implementation DDHTootView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _avatarImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _avatarImageView.wantsLayer = YES;
    _avatarImageView.layer.cornerRadius = 8;
    self.imageView = _avatarImageView;

    _boostersImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _boostersImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _boostersImageView.wantsLayer = YES;
    _boostersImageView.layer.cornerRadius = 4;

    _displayNameTextField = [NSTextField labelWithString:@"displayName"];
    _displayNameTextField.translatesAutoresizingMaskIntoConstraints = NO;

    _dateTextField = [NSTextField labelWithString:@"date"];
    _dateTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _dateTextField.textColor = [NSColor systemGrayColor];

    _acctTextField = [NSTextField labelWithString:@"acct"];
    _acctTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _acctTextField.font = [NSFont preferredFontForTextStyle:NSFontTextStyleFootnote options:@{}];
    _acctTextField.textColor = [NSColor secondaryLabelColor];

    _tootTextField = [NSTextField wrappingLabelWithString:@"toot text"];
    _tootTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _tootTextField.selectable = NO;
    [_tootTextField setContentCompressionResistancePriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [_tootTextField setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationVertical];
    [_tootTextField setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
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
    [self addSubview:_dateTextField];
    [self addSubview:_acctTextField];
    [self addSubview:_tootTextField];
    [self addSubview:_attachmentImageView];

    _avatarImageWidthConstraint = [_avatarImageView.widthAnchor constraintEqualToConstant:60];
    _textBottomConstraint = [_tootTextField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    _textBottomConstraint.priority = 999;
    _attachmentBottomConstraint = [_attachmentImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4];

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

      [_dateTextField.leadingAnchor constraintEqualToAnchor:_displayNameTextField.trailingAnchor constant:8],
      [_dateTextField.centerYAnchor constraintEqualToAnchor:_displayNameTextField.centerYAnchor],
      [_dateTextField.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],

      [_acctTextField.topAnchor constraintEqualToAnchor:_displayNameTextField.bottomAnchor],
      [_acctTextField.leadingAnchor constraintEqualToAnchor:_displayNameTextField.leadingAnchor],

      [_tootTextField.topAnchor constraintEqualToAnchor:_acctTextField.bottomAnchor constant:10],
      [_tootTextField.leadingAnchor constraintEqualToAnchor:_acctTextField.leadingAnchor],
      _textBottomConstraint,
      [_tootTextField.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],

      [_attachmentImageView.topAnchor constraintEqualToAnchor:_tootTextField.bottomAnchor constant:4],
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

- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter {

  [self setImagesForToot:toot imageLoader:imageLoader];
  [self setTextForToot:toot relativeDateTimeFormatter:relativeDateTimeFormatter];
  [self setAttachmentsForToot:toot imageLoader:imageLoader];
//  [self setColorsForToot:toot];
}

- (void)setTextForToot:(DDHToot *)toot relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter {
  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;

  NSString *trimmedContent = [tootToShow.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSData *contentData = [trimmedContent dataUsingEncoding:NSUTF16StringEncoding];
  DDHAccount *account = tootToShow.account;

  self.displayNameTextField.stringValue = account.displayName;
  self.acctTextField.stringValue = account.acct;

  self.dateTextField.stringValue = [relativeDateTimeFormatter localizedStringForDate:toot.createdAt relativeToDate:[NSDate date]];

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

//    self.languageLabel.stringValue = tootToShow.language;
  }
}

//- (void)setColorsForToot:(DDHToot *)toot {
//  if (toot.reblogged) {
//    self.boostButton.bezelColor = [NSColor colorNamed:@"colors/boosted"];
//  } else {
//    self.boostButton.bezelColor = nil;
//  }
//}

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
  self.attachmentBottomConstraint.active = NO;
  self.textBottomConstraint.active = YES;
  self.aspectConstraint.active = NO;
  DDHMediaAttachment * mediaAttachment = tootToShow.mediaAttachments.firstObject;
//  [tootToShow.mediaAttachments enumerateObjectsUsingBlock:^(DDHMediaAttachment * _Nonnull mediaAttachment, NSUInteger idx, BOOL * _Nonnull stop) {
    switch (mediaAttachment.type) {
      case DDHAttachmentTypeUnknown:
        break;
      case DDHAttachmentTypeImage:
        self.attachmentImageView.hidden = NO;
        self.textBottomConstraint.active = NO;
        self.attachmentBottomConstraint.active = YES;

        self.aspectConstraint = [self.attachmentImageView.widthAnchor constraintEqualToAnchor:self.attachmentImageView.heightAnchor multiplier:mediaAttachment.smallDimensions.aspect];
        self.aspectConstraint.active = YES;

        [imageLoader loadImageForURL:mediaAttachment.previewURL completionHandler:^(NSImage *image) {
          dispatch_async(dispatch_get_main_queue(), ^{
            self.attachmentImageView.image = image;
          });
        }];
        break;
    }
//  }];
}

- (void)mouseDown:(NSEvent *)event {
  //  NSLog(@"event: %@", event);

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
      //      NSLog(@"range: %@", [NSValue valueWithRange:range]);
      NSLog(@"attrs: %@", attrs);
      NSURL *url = (NSURL *)attrs[NSLinkAttributeName];
      if (self.clickHandler) {
        self.clickHandler(url);
      }
    }
  }];
}


@end
