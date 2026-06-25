//  Created by Dominik Hauser on 22.03.26.
//
//


#import "DDHAccountViewController.h"
#import "DDHAccountView.h"
#import "DDHAccount.h"
#import "DDHRelationship.h"
#import "DDHAPIClient.h"

@interface DDHAccountViewController ()
@property (strong) DDHAccount *account;
@property (strong) DDHRelationship *relationship;
@property (strong) DDHImageLoader *imageLoader;
@property (strong, nonatomic) DDHAccountView *contentView;
@property (strong) DDHAPIClient *apiClient;
@end

@implementation DDHAccountViewController

- (instancetype)initWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _account = account;
    _imageLoader = imageLoader;
    _apiClient = apiClient;
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

  self.contentView.followButton.target = self;
  self.contentView.followButton.action = @selector(followUnfollow:);

  __weak typeof(self) weakSelf = self;
  [self.apiClient relationshipForId:self.account.accountId completionHandler:^(DDHRelationship * _Nonnull relationship, NSError * _Nonnull error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.relationship = relationship;
      [weakSelf.contentView updateWithAccount:weakSelf.account relationship:relationship];
    });
  }];
}

- (void)followUnfollow:(NSButton *)sender {
  sender.enabled = NO;
  if (self.relationship.following) {
    [self.apiClient unfollowAccountWithId:self.account.accountId completionHandler:^(NSError * _Nonnull error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (nil == error) {
          sender.title = @"Follow";
        }
        sender.enabled = YES;
      });
    }];
  } else {
    [self.apiClient followAccountWithId:self.account.accountId completionHandler:^(NSError * _Nonnull error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (nil == error) {
          sender.title = @"Unfollow";
        }
        sender.enabled = YES;
      });
    }];
  }
}

@end
