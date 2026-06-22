//  Created by Dominik Hauser on 22.03.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHAccount;
@class DDHImageLoader;
@class DDHAPIClient;

NS_ASSUME_NONNULL_BEGIN

@interface DDHAccountViewController : NSViewController
- (instancetype)initWithAccount:(DDHAccount *)account imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient;
@end

NS_ASSUME_NONNULL_END
