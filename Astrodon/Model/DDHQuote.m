//  Created by Dominik Hauser on 16.01.26.
//  
//


#import "DDHQuote.h"
#import "DDHToot.h"

@implementation DDHQuote
- (instancetype)initWithDictionary:(NSDictionary *)dict dateFormatter:(NSISO8601DateFormatter *)dateFormatter {
  if (self = [super init]) {
    _quoteState = [self quoteStateFromString:dict[@"state"]];
    NSDictionary *quotedStatusDict = dict[@"quoted_status"];
    NSLog(@"quotedStatusDict: %@", quotedStatusDict);
    if ([quotedStatusDict isKindOfClass:[NSDictionary class]] && [quotedStatusDict count] > 0) {
      _quotedStatus = [[DDHToot alloc] initWithDictionary:quotedStatusDict dateFormatter:dateFormatter];
    } else {
//      NSAssert(NO, @"quotedStatusDict is nil");
      _quotedStatus = nil;
    }
  }
  return self;
}

- (DDHQuoteState)quoteStateFromString:(NSString *)string {
  DDHQuoteState state = DDHQuoteStateUnauthorized;
  if ([string isEqualToString:@"pending"]) {
    state = DDHQuoteStatePending;
  } else if ([string isEqualToString:@"accepted"]) {
    state = DDHQuoteStateAccepted;
  } else if ([string isEqualToString:@"rejected"]) {
    state = DDHQuoteStateRejected;
  } else if ([string isEqualToString:@"revoked"]) {
    state = DDHQuoteStateRevoked;
  } else if ([string isEqualToString:@"deleted"]) {
    state = DDHQuoteStateDeleted;
  } else if ([string isEqualToString:@"blocked_account"]) {
    state = DDHQuoteStateBlockedAccount;
  } else if ([string isEqualToString:@"blocked_domain"]) {
    state = DDHQuoteStateBlockedDomain;
  } else if ([string isEqualToString:@"muted_account"]) {
    state = DDHQuoteStateMutedAccount;
  }
  return state;
}
@end
