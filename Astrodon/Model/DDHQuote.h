//  Created by Dominik Hauser on 16.01.26.
//  
//


#import <Foundation/Foundation.h>
#import "DDHQuoteState.h"

NS_ASSUME_NONNULL_BEGIN

@class DDHToot;

@interface DDHQuote : NSObject
@property (assign) DDHQuoteState quoteState;
@property (strong) DDHToot *quotedStatus;
- (instancetype)initWithDictionary:(NSDictionary *)dict dateFormatter:(NSISO8601DateFormatter *)dateFormatter;
@end

NS_ASSUME_NONNULL_END
