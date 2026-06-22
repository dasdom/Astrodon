//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHEndpoint.h"

@class DDHToot;
@class DDHStatus;
@class DDHAccount;
@class DDHRelationship;
@class DDHContext;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAPIClient : NSObject
- (void)fetchTokenWithCode:(NSString *)code completionHandler:(void(^)(NSString *token, NSError *error))completionHandler;
- (void)homeTimelineSinceToot:(DDHToot *)toot completionHander:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler;
- (void)homeTimelineBeforeToot:(DDHToot *)toot completionHander:(void (^)(NSArray<DDHToot *> * _Nonnull, NSError * _Nonnull))completionHandler;
- (void)postNewStatus:(DDHStatus *)status completionHandler:(void(^)(NSError *error))completionHandler;
- (void)boostStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler;
- (void)favoriteStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler;
//- (void)accountForId:(NSString *)accountId completionHandler:(void(^)(DDHAccount *account, NSError *error))completionHandler;
- (void)relationshipForId:(NSString *)accountId completionHandler:(void(^)(DDHRelationship *relationship, NSError *error))completionHandler;
- (void)contextForId:(NSString *)statusId completionHandler:(void(^)(DDHContext *context, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
