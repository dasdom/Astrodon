//  Created by Dominik Hauser on 22.06.26.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHRelationship : NSObject
@property (strong) NSString *relationshipId;
@property BOOL following;
@property BOOL showingReblogs;
@property BOOL notifying;
@property (strong) NSArray<NSString *> *languages;
@property BOOL followedBy;
@property BOOL blocking;
@property BOOL blockedBy;
@property BOOL muting;
@property BOOL mutingNotifications;
@property (strong) NSDate *mutingExpiresAt;
@property BOOL requested;
@property BOOL requestedBy;
@property BOOL domainBlocking;
@property BOOL endorsed;
@property (strong) NSString *note;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
