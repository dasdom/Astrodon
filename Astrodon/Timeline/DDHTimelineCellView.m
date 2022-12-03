//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineCellView.h"
#import "DDHToot.h"
#import "DDHImageLoader.h"
#import "DDHAccount.h"
#import "DDHMediaAttachment.h"

@interface DDHTimelineCellView ()
@property NSLayoutConstraint *aspectConstraint;
@property IBOutlet NSLayoutConstraint *stackViewBottomConstraint;
@end

@implementation DDHTimelineCellView

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
  self.stackViewBottomConstraint.active = YES;
  self.aspectConstraint.active = NO;
  [tootToShow.mediaAttachments enumerateObjectsUsingBlock:^(DDHMediaAttachment * _Nonnull mediaAttachment, NSUInteger idx, BOOL * _Nonnull stop) {
    switch (mediaAttachment.type) {
      case DDHAttachmentTypeUnknown:
        break;
      case DDHAttachmentTypeImage:
        self.attachmentImageView.hidden = NO;
        self.aspectConstraint.active = NO;
        self.stackViewBottomConstraint.active = NO;
        self.aspectConstraint = [self.attachmentImageView.widthAnchor constraintEqualToAnchor:self.attachmentImageView.heightAnchor multiplier:mediaAttachment.smallDimensions.aspect];
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

@end
