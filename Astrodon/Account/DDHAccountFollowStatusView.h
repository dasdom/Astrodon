//  Created by Dominik Hauser on 22.06.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHAccount;
@class DDHRelationship;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAccountFollowStatusView : NSView
- (void)updateWithAccount:(DDHAccount *)account relationship:(DDHRelationship *)relationship;
@end

NS_ASSUME_NONNULL_END
