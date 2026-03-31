//  Created by Dominik Hauser on 29.03.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHAPIClient;
@class DDHToot;
@class DDHImageLoader;

NS_ASSUME_NONNULL_BEGIN

@interface DDHStatusContextViewController : NSViewController
- (instancetype)initWithAPIClient:(DDHAPIClient *)apiClient toot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader;
@end

NS_ASSUME_NONNULL_END
