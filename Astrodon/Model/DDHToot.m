//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHToot.h"
#import "DDHAccount.h"

@implementation DDHToot
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _content = dict[@"content"];

    NSDictionary *accountDict = dict[@"account"];
    _account = [[DDHAccount alloc] initWithDictionary:accountDict];
  }
  return self;
}
@end
