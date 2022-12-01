//  Created by Dominik Hauser on 01.12.22.
//  
//

#import "DDHImageDimensions.h"

@implementation DDHImageDimensions
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _aspect = [dict[@"aspect"] floatValue];
    _height = [dict[@"height"] integerValue];
    _width = [dict[@"width"] integerValue];
  }
  return self;
}
@end
