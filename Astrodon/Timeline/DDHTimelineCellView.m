//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineCellView.h"
#import "DDHToot.h"
#import "DDHImageLoader.h"
#import "DDHAccount.h"

@implementation DDHTimelineCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {

  [self setImagesForToot:toot imageLoader:imageLoader];
  [self setTextForToot:toot];
}

// MARK: - Helper
- (void)setTextForToot:(DDHToot *)toot {
  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;

  NSData *contentData = [tootToShow.content dataUsingEncoding:NSUTF16StringEncoding];
  DDHAccount *account = tootToShow.account;

  self.displayNameTextField.stringValue = account.displayName;
  self.acctTextField.stringValue = account.acct;

  if (tootToShow.sensitive) {
    self.textField.stringValue = tootToShow.spoilerText;

    self.showMoreButton.hidden = NO;
  } else {
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

@end
