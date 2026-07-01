//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Cocoa/Cocoa.h>
#import "DDHTimelineViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class DDHImageLoader;
@class DDHAPIClient;
@class DDHToot;

@interface DDHTimelineViewController : NSViewController
- (instancetype)initWithDelegate:(id<DDHTimelineViewControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient;
- (void)loadToots:(nullable id)sender withCompletionHandler:(nullable void(^)(void))completionHandler;
- (void)openTootInputReplyingToToot:(nullable DDHToot *)toot;
@end

NS_ASSUME_NONNULL_END
