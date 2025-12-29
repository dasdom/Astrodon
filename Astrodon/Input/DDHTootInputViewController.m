//  Created by Dominik Hauser on 29.12.25.
//
//


#import "DDHTootInputViewController.h"
#import "DDHTootInputView.h"
#import "DDHAPIClient.h"
#import "DDHStatus.h"

@interface DDHTootInputViewController ()
@property (nonatomic, strong) DDHTootInputView *contentView;
@property (strong) DDHAPIClient *apiClient;
@end

@implementation DDHTootInputViewController

- (DDHTootInputView *)contentView {
  return (DDHTootInputView *)self.view;
}

- (void)loadView {
  self.view = [[DDHTootInputView alloc] initWithFrame:NSMakeRect(0, 0, 300, 200)];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.apiClient = [DDHAPIClient new];

  self.contentView.sendButton.target = self;
  self.contentView.sendButton.action = @selector(send:);
}

- (void)send:(NSButton *)sender {
  [self.contentView.progressIndicator startAnimation:self];
  self.contentView.progressIndicator.hidden = NO;

  DDHStatus *status = [[DDHStatus alloc] initWithText:self.contentView.inputTextView.string];

  typeof(self) __weak weakSelf = self;
  [self.apiClient postNewStatus:status completionHandler:^(NSError * _Nonnull error) {
    if (nil == error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.contentView.progressIndicator.hidden = YES;
        [weakSelf.contentView.progressIndicator stopAnimation:weakSelf];
        [weakSelf.contentView.window close];
      });
    } else {
      NSLog(@"error: %@", error);
    }
  }];
}

@end
