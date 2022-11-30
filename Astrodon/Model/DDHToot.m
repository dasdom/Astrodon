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

    _sensitive = [dict[@"sensitive"] boolValue];

    _spoilerText = dict[@"spoiler_text"];

    NSDictionary *reblogDict = dict[@"reblog"];
    if ([reblogDict isKindOfClass:[NSDictionary class]]) {
      _boostedToot = [[DDHToot alloc] initWithDictionary:reblogDict];
    }
  }
  return self;
}

- (BOOL)isBoost {
  return self.boostedToot;
}

@end
