//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHAccount.h"

@implementation DDHAccount
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _acct = dict[@"acct"];
    _displayName = dict[@"display_name"];
    _accountId = dict[@"id"];

    NSString *avatarURLString = dict[@"avatar"];
    _avatarURL = [NSURL URLWithString:avatarURLString];

    NSString *headerURLString = dict[@"header"];
    _headerURL = [NSURL URLWithString:headerURLString];
  }
  return self;
}
@end
