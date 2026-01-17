//  Created by Dominik Hauser on 29.12.25.
//  
//


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHToot;
@class DDHImageLoader;

@interface DDHTootInputViewController : NSViewController
- (instancetype)initWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter;
@end

NS_ASSUME_NONNULL_END
