//  Created by Dominik Hauser on 05.07.26.
//  
//


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHImageLoader;
@class DDHAPIClient;
@class DDHTimelineViewController;

@interface DDHMainViewController : NSViewController
- (instancetype)initWithImageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient;
- (DDHTimelineViewController *)homeViewController;
- (void)closeDetails;
@end

NS_ASSUME_NONNULL_END
