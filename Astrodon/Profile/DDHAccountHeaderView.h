//  Created by Dominik Hauser on 20.06.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHAccount;
@class DDHImageLoader;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAccountHeaderView : NSView
- (void)updateWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader;
@end

NS_ASSUME_NONNULL_END
