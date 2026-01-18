//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHTimelineViewController : NSViewController
- (void)loadToots:(nullable id)sender withCompletionHandler:(nullable void(^)(void))completionHandler;
@end

NS_ASSUME_NONNULL_END
