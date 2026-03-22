//  Created by Dominik Hauser on 21.03.26.
//
//


#import "DDHImageViewController.h"
#import "DDHImageView.h"
#import "DDHMediaAttachment.h"
#import "DDHImageLoader.h"

@interface DDHImageViewController ()
@property (strong) DDHMediaAttachment *mediaAttachment;
@property (strong) DDHImageLoader *imageLoader;
@end

@implementation DDHImageViewController

- (instancetype)initWithMediaAttachment:(DDHMediaAttachment *)mediaAttachment imageLoader:(DDHImageLoader *)imageLoader {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _mediaAttachment = mediaAttachment;
    _imageLoader = imageLoader;
  }
  return self;
}

- (void)loadView {
  self.view = [[DDHImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 600)];
}

- (DDHImageView *)contentView {
  return (DDHImageView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak typeof(self)weakSelf = self;
  [self.imageLoader loadImageForURL:self.mediaAttachment.url completionHandler:^(NSImage *image) {
    [weakSelf.contentView updateWithImage:image];
  }];
}

@end
