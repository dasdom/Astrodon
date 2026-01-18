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

    _favoriteButton = [[NSButton alloc] init];
    _favoriteButton.translatesAutoresizingMaskIntoConstraints = NO;
    _favoriteButton.image = [NSImage imageWithSystemSymbolName:@"star" accessibilityDescription:@"favorite"];

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
    [self addSubview:_favoriteButton];
    [self addSubview:_boostButton];
    [self addSubview:_languageLabel];


    _tootViewToButtonConstraint = [_boostButton.topAnchor constraintEqualToAnchor:_tootView.bottomAnchor];
    _tootViewToQuoteViewConstraint = [_quoteTootView.topAnchor constraintEqualToAnchor:_tootView.bottomAnchor];

    [NSLayoutConstraint activateConstraints:@[
      [_tootView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_tootView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_tootView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

      [_quoteTootView.leadingAnchor constraintEqualToAnchor:_tootView.leadingAnchor constant:4],
      [_quoteTootView.bottomAnchor constraintEqualToAnchor:_boostButton.topAnchor constant:-4],
      [_quoteTootView.trailingAnchor constraintEqualToAnchor:_tootView.trailingAnchor constant:-4],

      _tootViewToButtonConstraint,
      [_boostButton.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
      [_boostButton.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],

      [_favoriteButton.trailingAnchor constraintEqualToAnchor:_boostButton.leadingAnchor constant:-4],
      [_favoriteButton.bottomAnchor constraintEqualToAnchor:_boostButton.bottomAnchor],

      [_replyButton.trailingAnchor constraintEqualToAnchor:_favoriteButton.leadingAnchor constant:-4],
      [_replyButton.bottomAnchor constraintEqualToAnchor:_favoriteButton.bottomAnchor],

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

- (void)setColorsForToot:(DDHToot *)toot {
  if (toot.reblogged) {
    self.boostButton.bezelColor = [NSColor colorNamed:@"colors/boosted"];
  } else {
    self.boostButton.bezelColor = nil;
  }
  if (toot.favourited) {
    self.favoriteButton.bezelColor = [NSColor colorNamed:@"colors/boosted"];
    self.favoriteButton.image = [NSImage imageWithSystemSymbolName:@"star.fill" accessibilityDescription:@"favorite filled"];
  } else {
    self.favoriteButton.bezelColor = nil;
    self.favoriteButton.image = [NSImage imageWithSystemSymbolName:@"star" accessibilityDescription:@"favorite"];
  }
}

@end
