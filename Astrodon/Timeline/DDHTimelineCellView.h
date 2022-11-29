//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHTimelineCellView : NSTableCellView
@property IBOutlet NSTextField *displayNameTextField;
@property IBOutlet NSTextField *acctTextField;
@property IBOutlet NSImageView *booterImageView;
@property IBOutlet NSLayoutConstraint *avatarImageWidthConstraint;
@end

NS_ASSUME_NONNULL_END
