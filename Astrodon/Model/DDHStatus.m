//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHStatus.h"

@implementation DDHStatus

- (instancetype)initWithText:(NSString *)text {
  if (self = [super init]) {
    _text = text;
  }
  return self;
}

- (NSData *)data {
  NSDictionary *dictionary = @{@"status": self.text};
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
}
@end
