//  Created by Dominik Hauser on 21.03.26.
//  
//


#import "DDHImageView.h"

@interface DDHImageView ()
@property (strong) NSImageView *imageView;
@end

@implementation DDHImageView

- (instancetype)initWithFrame:(NSRect)frameRect {
  if (self = [super initWithFrame:frameRect]) {
    _imageView = [[NSImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_imageView];

    [NSLayoutConstraint activateConstraints:@[
      [_imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [_imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [_imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      [_imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateWithImage:(NSImage *)image {
  _imageView.image = image;
}

@end
