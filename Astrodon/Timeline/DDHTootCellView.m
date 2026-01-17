//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTootCellView.h"
#import "DDHToot.h"
#import "DDHImageLoader.h"
#import "DDHTootView.h"
#import "DDHQuote.h"

@interface DDHTootCellView ()
@property (strong) DDHTootView *quoteTootView;
@property (strong) NSLayoutConstraint *tootViewToButtonConstraint;
@property (strong) NSLayoutConstraint *tootViewToQuoteViewConstraint;
@end

@implementation DDHTootCellView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _tootView = [[DDHTootView alloc] init];
    _tootView.translatesAutoresizingMaskIntoConstraints = NO;

    _quoteTootView = [[DDHTootView alloc] init];
    _quoteTootView.translatesAutoresizingMaskIntoConstraints = NO;
    _quoteTootView.hidden = YES;
    _quoteTootView.wantsLayer = YES;
    _quoteTootView.layer.cornerRadius = 5;
    _quoteTootView.layer.borderWidth = 1;
    _quoteTootView.layer.borderColor = [NSColor lightGrayColor].CGColor;

    _replyButton = [[NSButton alloc] init];
    _replyButton.translatesAutoresizingMaskIntoConstraints = NO;
    _replyButton.image = [NSImage imageWithSystemSymbolName:@"arrow.turn.up.left" accessibilityDescription:@"reply"];

    _boostButton = [[NSButton alloc] init];
    _boostButton.translatesAutoresizingMaskIntoConstraints = NO;
    _boostButton.image = [NSImage imageWithSystemSymbolName:@"arrow.2.squarepath" accessibilityDescription:@"reply"];

    _languageLabel = [NSTextField labelWithString:@"en"];
    _languageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _languageLabel.font = [NSFont labelFontOfSize:NSFont.smallSystemFontSize];
    _languageLabel.textColor = [NSColor secondaryLabelColor];

    [self addSubview:_tootView];
    [self addSubview:_quoteTootView];
    [self addSubview:_replyButton];
    [self addSubview:_boostButton];
    [self addSubview:_languageLabel];


    _tootViewToButtonConstraint = [_boostButton.topAnchor constraintEqualToAnchor:_tootView.bottomAnchor];
    _tootViewToQuoteViewConstraint = [_quoteTootView.topAnchor constraintEqualToAnchor:_tootView.bottomAnchor];

    [NSLayoutConstraint activateConstraints:@[
      [_tootView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_tootView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_tootView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

//      _tootViewToQuoteViewConstraint,
      [_quoteTootView.leadingAnchor constraintEqualToAnchor:_tootView.leadingAnchor constant:4],
      [_quoteTootView.bottomAnchor constraintEqualToAnchor:_boostButton.topAnchor constant:-4],
      [_quoteTootView.trailingAnchor constraintEqualToAnchor:_tootView.trailingAnchor constant:-4],

      _tootViewToButtonConstraint,
      [_boostButton.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
      [_boostButton.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],

      [_replyButton.trailingAnchor constraintEqualToAnchor:_boostButton.leadingAnchor constant:-4],
      [_replyButton.bottomAnchor constraintEqualToAnchor:_boostButton.bottomAnchor],

      [_languageLabel.topAnchor constraintEqualToAnchor:_boostButton.bottomAnchor],
      [_languageLabel.centerXAnchor constraintEqualToAnchor:_boostButton.centerXAnchor],
    ]];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter {

  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;

  self.languageLabel.stringValue = tootToShow.language;

  [self.tootView updateWithToot:toot imageLoader:imageLoader relativeDateTimeFormatter:relativeDateTimeFormatter];
  [self setColorsForToot:toot];

  if (tootToShow.quote) {
    self.tootViewToButtonConstraint.active = NO;
    self.tootViewToQuoteViewConstraint.active = YES;
    self.quoteTootView.hidden = NO;
    [self.quoteTootView updateWithToot:tootToShow.quote.quotedStatus imageLoader:imageLoader relativeDateTimeFormatter:relativeDateTimeFormatter];
  } else {
    self.quoteTootView.hidden = YES;
    self.tootViewToButtonConstraint.active = YES;
    self.tootViewToQuoteViewConstraint.active = NO;
  }
}

// MARK: - Helper
//- (void)setTextForToot:(DDHToot *)toot relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter {
//  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;
//
//  NSString *trimmedContent = [tootToShow.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//  NSData *contentData = [trimmedContent dataUsingEncoding:NSUTF16StringEncoding];
//  DDHAccount *account = tootToShow.account;
//
//  self.displayNameTextField.stringValue = account.displayName;
//  self.acctTextField.stringValue = account.acct;
//
//  self.dateTextField.stringValue = [relativeDateTimeFormatter localizedStringForDate:toot.createdAt relativeToDate:[NSDate date]];
//
//  if (tootToShow.sensitive && !tootToShow.showsSensitive) {
//    self.textField.stringValue = tootToShow.spoilerText;
//
//    self.showMoreButton.hidden = NO;
//  } else {
//    if (tootToShow.showsSensitive) {
//      self.showMoreButton.hidden = NO;
//    }
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithHTML:contentData documentAttributes:nil];
//    [attributedString addAttributes:@{NSFontAttributeName: [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}]}
//                              range:NSMakeRange(0, attributedString.length)];
//    self.textField.attributedStringValue = attributedString;
//
//    self.showMoreButton.hidden = YES;
//
//    self.languageLabel.stringValue = tootToShow.language;
//  }
//}

- (void)setColorsForToot:(DDHToot *)toot {
  if (toot.reblogged) {
    self.boostButton.bezelColor = [NSColor colorNamed:@"colors/boosted"];
  } else {
    self.boostButton.bezelColor = nil;
  }
}

//- (void)setImagesForToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {
//  if ([toot isBoost]) {
//    [imageLoader loadImageForURL:toot.boostedToot.account.avatarURL completionHandler:^(NSImage *image) {
//      if (image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//          self.imageView.image = image;
//        });
//      }
//    }];
//    [imageLoader loadImageForURL:toot.account.avatarURL completionHandler:^(NSImage *image) {
//      if (image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//          self.boostersImageView.image = image;
//        });
//      }
//    }];
//    self.boostersImageView.hidden = NO;
//    self.avatarImageWidthConstraint.constant = 45;
//  } else {
//    [imageLoader loadImageForURL:toot.account.avatarURL completionHandler:^(NSImage *image) {
//      if (image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//          self.imageView.image = image;
//        });
//      }
//    }];
//    self.boostersImageView.hidden = YES;
//    self.avatarImageWidthConstraint.constant = 60;
//  }
//}

//- (void)setAttachmentsForToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {
//  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;
//  self.attachmentImageView.hidden = YES;
//  self.textBottomConstraint.active = YES;
//  self.aspectConstraint.active = NO;
//  [tootToShow.mediaAttachments enumerateObjectsUsingBlock:^(DDHMediaAttachment * _Nonnull mediaAttachment, NSUInteger idx, BOOL * _Nonnull stop) {
//    switch (mediaAttachment.type) {
//      case DDHAttachmentTypeUnknown:
//        break;
//      case DDHAttachmentTypeImage:
//        self.attachmentImageView.hidden = NO;
//        self.aspectConstraint.active = NO;
//        self.textBottomConstraint.active = NO;
//        self.attachmentBottomConstraint.active = YES;
//        self.aspectConstraint = [self.attachmentImageView.widthAnchor constraintEqualToAnchor:self.attachmentImageView.heightAnchor multiplier:mediaAttachment.smallDimensions.aspect];
//        self.aspectConstraint.active = YES;
//        [imageLoader loadImageForURL:mediaAttachment.previewURL completionHandler:^(NSImage *image) {
//          dispatch_async(dispatch_get_main_queue(), ^{
//            self.attachmentImageView.image = image;
//          });
//        }];
//        break;
//    }
//  }];
//}

//- (void)mouseDown:(NSEvent *)event {
////  NSLog(@"event: %@", event);
//
//  NSAttributedString *attributedString = [self.tootTextField.attributedStringValue copy];
//  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
//  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
//  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.tootTextField.bounds.size];
//
//  textContainer.lineFragmentPadding = 0;
//  textContainer.maximumNumberOfLines = self.tootTextField.maximumNumberOfLines;
//  textContainer.lineBreakMode = self.tootTextField.lineBreakMode;
//
//  [layoutManager addTextContainer:textContainer];
//  [textStorage addLayoutManager:layoutManager];
//
//  NSPoint pointInWindow = [event locationInWindow];
//  NSPoint convertedPoint = [self.tootTextField convertPoint:pointInWindow fromView:nil];
//  NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:convertedPoint inTextContainer:textContainer];
//  NSUInteger characterIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
//
//  [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//    if (NSLocationInRange(characterIndex, range)) {
////      NSLog(@"range: %@", [NSValue valueWithRange:range]);
//      NSLog(@"attrs: %@", attrs);
//      NSURL *url = (NSURL *)attrs[NSLinkAttributeName];
//      if (self.clickHandler) {
//        self.clickHandler(url);
//      }
//    }
//  }];
//}

@end
