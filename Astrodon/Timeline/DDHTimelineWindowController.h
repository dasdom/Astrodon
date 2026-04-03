//  Created by Dominik Hauser on 29.12.25.
//  
//


#import <Cocoa/Cocoa.h>
#import "DDHTimelineWindowControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class DDHImageLoader;
@class DDHAPIClient;

@interface DDHTimelineWindowController : NSWindowController
- (instancetype)initWithDelegate:(id<DDHTimelineWindowControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient;
@end

NS_ASSUME_NONNULL_END
