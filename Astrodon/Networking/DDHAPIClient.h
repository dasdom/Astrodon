//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>

@class DDHToot;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAPIClient : NSObject
- (void)publicTimeline:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
