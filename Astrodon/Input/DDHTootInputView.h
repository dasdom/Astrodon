//  Created by Dominik Hauser on 29.12.25.
//  
//


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHTootView;

@interface DDHTootInputView : NSView
@property (strong) DDHTootView *tootView;
@property (strong) NSTextView *inputTextView;
@property (strong) NSButton *sendButton;
@property (strong) NSProgressIndicator *progressIndicator;
- (instancetype)initWithFrame:(NSRect)frameRect showToot:(BOOL)showToot;
- (void)scrollUp;
@end

NS_ASSUME_NONNULL_END
