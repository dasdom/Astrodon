//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHAccount.h"

@implementation DDHAccount
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _acct = dict[@"acct"];
    _displayName = dict[@"display_name"];
    NSString *avatarURLString = dict[@"avatar"];
    _avatarURL = [NSURL URLWithString:avatarURLString];
  }
  return self;
}
@end
