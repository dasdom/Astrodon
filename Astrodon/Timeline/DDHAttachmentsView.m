//  Created by Dominik Hauser on 12.06.26.
//  
//


#import "DDHAttachmentsView.h"
#import "DDHMediaAttachment.h"
#import "DDHImageLoader.h"

@interface DDHAttachmentsView ()
@property (strong) NSImageView *attachmentImageView;
@property (strong) NSLayoutConstraint *aspectConstraint;
@end

@implementation DDHAttachmentsView

- (instancetype)initWithFrame:(NSRect)frame {
  if (self = [super initWithFrame:frame]) {
    _attachmentImageView = [[NSImageView alloc] initWithFrame:frame];
    _attachmentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _attachmentImageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [_attachmentImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [_attachmentImageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];

    [self addSubview:_attachmentImageView];

    [NSLayoutConstraint activateConstraints:@[
      [_attachmentImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_attachmentImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_attachmentImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_attachmentImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}

- (void)updateWithMediaAttachments:(NSArray<DDHMediaAttachment *> *)attachments imageLoader:(DDHImageLoader *)imageLoader {

  self.hidden = YES;

  DDHMediaAttachment *mediaAttachment = attachments.firstObject;
  switch (mediaAttachment.type) {
    case DDHAttachmentTypeUnknown:
      break;
    case DDHAttachmentTypeImage:
      self.hidden = NO;

      self.aspectConstraint.active = NO;
      self.aspectConstraint = [self.attachmentImageView.widthAnchor constraintEqualToAnchor:self.attachmentImageView.heightAnchor multiplier:mediaAttachment.smallDimensions.aspect];
      self.aspectConstraint.active = YES;

      [imageLoader loadImageForURL:mediaAttachment.previewURL completionHandler:^(NSImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.attachmentImageView.image = image;

          self.needsUpdateConstraints = YES;
          self.needsLayout = YES;
          self.needsDisplay = YES;
        });
      }];
      break;
  }
}

- (BOOL)attachmentsVisible {
  return (NO == self.hidden);
}

@end
