//  Created by Dominik Hauser on 22.03.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHAccount;
@class DDHImageLoader;
@class DDHRelationship;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAccountView : NSView
- (void)updateWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader;
- (void)updateWithAccount:(DDHAccount *)account relationship:(DDHRelationship *)relationship;
- (NSButton *)followButton;
@end

NS_ASSUME_NONNULL_END
