//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHToot.h"

@implementation DDHToot
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _content = dict[@"content"];
  }
  return self;
}
@end
