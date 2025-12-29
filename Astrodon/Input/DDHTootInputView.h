//  Created by Dominik Hauser on 29.12.25.
//  
//


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHTootInputView : NSView
@property (nonatomic, strong) NSTextView *inputTextView;
@property (nonatomic, strong) NSButton *sendButton;
@property (nonatomic, strong) NSProgressIndicator *progressIndicator;
@end

NS_ASSUME_NONNULL_END
