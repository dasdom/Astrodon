//  Created by Dominik Hauser on 22.03.26.
//
//


#import "DDHAccountViewController.h"
#import "DDHAccountView.h"
#import "DDHAccount.h"

@interface DDHAccountViewController ()
@property (strong) DDHAccount *account;
@property (strong) DDHImageLoader *imageLoader;
@property (strong, nonatomic) DDHAccountView *contentView;
@end

@implementation DDHAccountViewController

- (instancetype)initWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _account = account;
    _imageLoader = imageLoader;
  }
  return self;
}

- (void)loadView {
  self.view = [[DDHAccountView alloc] initWithFrame:CGRectMake(0, 0, 480, 600)];
}

- (DDHAccountView *)contentView {
  return (DDHAccountView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.contentView updateWithAccount:self.account imageLoader:self.imageLoader];
}

@end
