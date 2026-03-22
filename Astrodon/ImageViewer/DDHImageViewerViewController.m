//  Created by Dominik Hauser on 21.03.26.
//
//


#import "DDHImageViewerViewController.h"
#import "DDHImageViewerView.h"
#import "DDHMediaAttachment.h"
#import "DDHImageLoader.h"

@interface DDHImageViewerViewController ()
@property (strong) DDHMediaAttachment *mediaAttachment;
@property (strong) DDHImageLoader *imageLoader;
@end

@implementation DDHImageViewerViewController

- (instancetype)initWithMediaAttachment:(DDHMediaAttachment *)mediaAttachment imageLoader:(DDHImageLoader *)imageLoader {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _mediaAttachment = mediaAttachment;
    _imageLoader = imageLoader;
  }
  return self;
}

- (void)loadView {
  self.view = [[DDHImageViewerView alloc] initWithFrame:CGRectMake(0, 0, 480, 600)];
}

- (DDHImageViewerView *)contentView {
  return (DDHImageViewerView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak typeof(self)weakSelf = self;
  [self.imageLoader loadImageForURL:self.mediaAttachment.url completionHandler:^(NSImage *image) {
    [weakSelf.contentView updateWithImage:image];
  }];
}

@end
