//  Created by Dominik Hauser on 29.06.26.
//  
//


#import "DDHTag.h"

@implementation DDHTag
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _name = dict[@"name"];
    _urlString = dict[@"url"];
  }
  return self;
}
@end
