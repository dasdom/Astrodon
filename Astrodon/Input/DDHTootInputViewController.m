//  Created by Dominik Hauser on 29.12.25.
//
//


#import "DDHTootInputViewController.h"
#import "DDHTootInputView.h"
#import "DDHAPIClient.h"
#import "DDHStatus.h"
#import "DDHToot.h"
#import "DDHTootView.h"

@interface DDHTootInputViewController ()
@property (nonatomic, strong) DDHTootInputView *contentView;
@property (strong) DDHAPIClient *apiClient;
@property (strong) DDHToot *toot;
@property (strong) DDHImageLoader *imageLoader;
@property (strong) NSRelativeDateTimeFormatter *relativeDateTimeFormatter;
@end

@implementation DDHTootInputViewController

- (instancetype)initWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter {
  if (self = [super init]) {
    _toot = toot;
    _imageLoader = imageLoader;
    _relativeDateTimeFormatter = relativeDateTimeFormatter;
  }
  return self;
}

- (DDHTootInputView *)contentView {
  return (DDHTootInputView *)self.view;
}

- (void)loadView {
  self.view = [[DDHTootInputView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400) showToot:(nil != self.toot)];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.apiClient = [DDHAPIClient new];

  self.contentView.sendButton.target = self;
  self.contentView.sendButton.action = @selector(send:);

  if (self.toot) {
    [self.contentView.tootView updateWithToot:self.toot imageLoader:self.imageLoader relativeDateTimeFormatter:self.relativeDateTimeFormatter];
    [self.contentView scrollUp];
  }
}

- (void)send:(NSButton *)sender {
  [self.contentView.progressIndicator startAnimation:self];
  self.contentView.progressIndicator.hidden = NO;

  DDHStatus *status = [[DDHStatus alloc] initWithText:self.contentView.inputTextView.string inReplyToId:self.toot.statusId];

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
