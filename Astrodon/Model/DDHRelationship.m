//  Created by Dominik Hauser on 22.06.26.
//  
//


#import "DDHRelationship.h"

@implementation DDHRelationship

- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _relationshipId = dict[@"id"];

    _following = [dict[@"following"] boolValue];
    _showingReblogs = [dict[@"showing_reblogs"] boolValue];
    _notifying = [dict[@"notifying"] boolValue];

    _languages = dict[@"languages"];

    _followedBy = [dict[@"followed_by"] boolValue];
    _blocking = [dict[@"blocking"] boolValue];
    _blockedBy = [dict[@"blocked_by"] boolValue];
    _muting = [dict[@"muting"] boolValue];
    _mutingNotifications = [dict[@"muting_notifications"] boolValue];

    NSISO8601DateFormatter *dateFormatter = [[NSISO8601DateFormatter alloc] init];
    _mutingExpiresAt = [dateFormatter dateFromString:dict[@"muting_expires_at"]];

    _requested = [dict[@"requested"] boolValue];
    _requestedBy = [dict[@"requested_by"] boolValue];
    _domainBlocking = [dict[@"domain_blocking"] boolValue];
    _endorsed = [dict[@"endorsed"] boolValue];
    _note = dict[@"note"];
  }
  return self;
}

@end
