//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHEndpoint.h"

@class DDHToot;
@class DDHStatus;
@class DDHAccount;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAPIClient : NSObject
- (void)fetchTokenWithCode:(NSString *)code completionHandler:(void(^)(NSString *token, NSError *error))completionHandler;
- (void)timelineFromEndpoint:(DDHEndpoint)endpoint sinceId:(NSString *)sinceId completionHandler:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler;
- (void)postNewStatus:(DDHStatus *)status completionHandler:(void(^)(NSError *error))completionHandler;
- (void)boostStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler;
- (void)favoriteStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler;
- (void)accountForId:(NSString *)accountId completionHandler:(void(^)(DDHAccount *account, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
