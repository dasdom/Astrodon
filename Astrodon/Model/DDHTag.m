//  Created by Dominik Hauser on 29.06.26.
//  
//


#import "DDHTag.h"

@implementation DDHTag
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _name = dict[@"name"];
    NSString *urlString = dict[@"url"];
    _url = [NSURL URLWithString:urlString];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@", self.name, self.url];
}
@end
