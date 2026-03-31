//  Created by Dominik Hauser on 30.03.26.
//  
//


#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)
- (NSArray *)map:(id (^)(id element))block {
  NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
  [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [mutableArray addObject:block(obj)];
  }];
  return [mutableArray copy];
}
@end
