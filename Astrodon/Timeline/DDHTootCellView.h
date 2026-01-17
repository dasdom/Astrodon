//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Cocoa/Cocoa.h>

@class DDHToot;
@class DDHImageLoader;
@class DDHTootView;

NS_ASSUME_NONNULL_BEGIN

@interface DDHTootCellView : NSTableCellView
@property (strong) DDHTootView *tootView;
@property (nonatomic, strong) NSButton *replyButton;
@property (nonatomic, strong) NSButton *boostButton;
@property (strong) NSTextField *languageLabel;
- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader relativeDateTimeFormatter:(NSRelativeDateTimeFormatter *)relativeDateTimeFormatter;
@end

NS_ASSUME_NONNULL_END
