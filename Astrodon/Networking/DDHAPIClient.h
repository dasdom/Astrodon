//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHEndpoint.h"

@class DDHToot;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAPIClient : NSObject
- (void)fetchTokenWithCode:(NSString *)code completionHandler:(void(^)(NSString *token, NSError *error))completionHandler;
- (void)timelineFromEndpoint:(DDHEndpoint)endpoint completionHandler:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
