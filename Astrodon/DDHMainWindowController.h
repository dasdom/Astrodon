//  Created by Dominik Hauser on 05.07.26.
//  
//


#import <Cocoa/Cocoa.h>
#import "DDHMainWindowControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class DDHImageLoader;
@class DDHAPIClient;

@interface DDHMainWindowController : NSWindowController
- (instancetype)initWithDelegate:(id<DDHMainWindowControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient;
@end

NS_ASSUME_NONNULL_END
