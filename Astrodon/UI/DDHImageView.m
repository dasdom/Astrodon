//  Created by Dominik Hauser on 14.06.26.
//
//


#import "DDHImageView.h"

@implementation DDHImageView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
//    self.layer = [[CALayer alloc] init];
    self.wantsLayer = YES;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
  }
  return self;
}

- (void)setImage:(NSImage *)image {
  _image = image;
  CGFloat desiredScaleFactor = [self.window backingScaleFactor];
  CGFloat actualScaleFactor = [image recommendedLayerContentsScale:desiredScaleFactor];

  id layerContents = [image layerContentsForContentsScale:actualScaleFactor];

  self.layer.contents = layerContents;
  self.layer.contentsScale = actualScaleFactor;
}

@end
