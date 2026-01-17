//  Created by Dominik Hauser on 16.01.26.
//  
//


#import <Cocoa/Cocoa.h>

@class DDHToot;
@class DDHImageLoader;

NS_ASSUME_NONNULL_BEGIN

@interface DDHTootView : NSView
@property (nonatomic, copy, nullable) void (^clickHandler)(NSURL *url);
- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter;
@end

NS_ASSUME_NONNULL_END
