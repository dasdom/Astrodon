//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Cocoa/Cocoa.h>

@class DDHToot;
@class DDHImageLoader;

NS_ASSUME_NONNULL_BEGIN

@interface DDHTimelineCellView : NSTableCellView
@property (nonatomic, strong) NSButton *replyButton;
@property (nonatomic, strong) NSButton *boostButton;
@property (nonatomic, copy, nullable) void (^clickHandler)(NSURL *url);
- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter;
@end

NS_ASSUME_NONNULL_END
