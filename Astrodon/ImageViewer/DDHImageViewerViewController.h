//  Created by Dominik Hauser on 21.03.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHMediaAttachment;
@class DDHImageLoader;

NS_ASSUME_NONNULL_BEGIN

@interface DDHImageViewerViewController : NSViewController
- (instancetype)initWithMediaAttachment:(DDHMediaAttachment *)mediaAttachment imageLoader:(DDHImageLoader *)imageLoader;
@end

NS_ASSUME_NONNULL_END
