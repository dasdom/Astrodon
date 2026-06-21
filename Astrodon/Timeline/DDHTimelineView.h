//  Created by Dominik Hauser on 26.12.25.
//  
//


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHTimelineView : NSView
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSScrollView *scrollView;
- (void)startTopSpinner;
- (void)stopTopSpinner;
- (void)startBottomSpinner;
- (void)stopBottomSpinner;
@end

NS_ASSUME_NONNULL_END
