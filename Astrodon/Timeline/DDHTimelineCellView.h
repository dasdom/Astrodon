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
- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader;
@end

NS_ASSUME_NONNULL_END
