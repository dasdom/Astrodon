//  Created by Dominik Hauser on 29.12.25.
//  
//


#import "DDHStatus.h"

@implementation DDHStatus

- (instancetype)initWithText:(NSString *)text inReplyToId:(nullable NSString *)inReplyToId {
  if (self = [super init]) {
    _text = text;
    _inReplyToId = inReplyToId;
  }
  return self;
}

- (NSData *)data {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"status": self.text}];
  if (self.inReplyToId) {
    [dictionary setValue:self.inReplyToId forKey:@"in_reply_to_id"];
  }
  NSError *error;
  return [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
}
@end
