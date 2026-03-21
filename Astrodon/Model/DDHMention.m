//  Created by Dominik Hauser on 18.01.26.
//  
//


#import "DDHMention.h"

@implementation DDHMention
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _mentionId = dict[@"id"];
    _userName = dict[@"username"];
    _urlString = dict[@"url"];
    _acct = dict[@"acct"];
  }
  return self;
}
@end
