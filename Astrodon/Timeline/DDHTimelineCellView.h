//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Cocoa/Cocoa.h>

@class DDHToot;
@class DDHImageLoader;

NS_ASSUME_NONNULL_BEGIN

@interface DDHTimelineCellView : NSTableCellView
@property IBOutlet NSTextField *displayNameTextField;
@property IBOutlet NSTextField *acctTextField;
@property IBOutlet NSImageView *boostersImageView;
@property IBOutlet NSLayoutConstraint *avatarImageWidthConstraint;
@property IBOutlet NSButton *showMoreButton;
@property IBOutlet NSImageView *attachmentImageView;
- (void)updateWithToot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader;
@end

NS_ASSUME_NONNULL_END
