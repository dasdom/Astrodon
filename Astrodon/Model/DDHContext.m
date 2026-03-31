//  Created by Dominik Hauser on 29.03.26.
//  
//


#import "DDHContext.h"
#import "DDHToot.h"

@implementation DDHContext
- (instancetype)initWithDictionary:(NSDictionary *)dict dataFormatter:(NSISO8601DateFormatter *)dateFormatter {
  if (self = [super init]) {

    NSArray<NSDictionary *> *rawAncestorsArray = dict[@"ancestors"];
    NSMutableArray<DDHToot *> *ancestorsArray = [[NSMutableArray alloc] initWithCapacity:[rawAncestorsArray count]];
    for (NSDictionary *rawAncestorDictionary in rawAncestorsArray) {
      DDHToot *ancestor = [[DDHToot alloc] initWithDictionary:rawAncestorDictionary dateFormatter:dateFormatter];
      [ancestorsArray addObject:ancestor];
    }
    _ancestors = [ancestorsArray copy];

    NSArray<NSDictionary *> *rawDescendantsArray = dict[@"descendants"];
    NSMutableArray<DDHToot *> *descendantsArray = [[NSMutableArray alloc] initWithCapacity:[rawDescendantsArray count]];
    for (NSDictionary *rawDescendantDictionary in rawDescendantsArray) {
      DDHToot *descendant = [[DDHToot alloc] initWithDictionary:rawDescendantDictionary dateFormatter:dateFormatter];
      [descendantsArray addObject:descendant];
    }
    _descendants = [descendantsArray copy];
  }
  return self;
}

- (instancetype)init {
  if (self = [super init]) {
    _ancestors = [[NSArray alloc] init];
    _descendants = [[NSArray alloc] init];
  }
  return self;
}
@end
