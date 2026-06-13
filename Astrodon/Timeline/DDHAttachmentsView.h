//  Created by Dominik Hauser on 12.06.26.
//  
//


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHMediaAttachment;
@class DDHImageLoader;

@interface DDHAttachmentsView : NSView
- (void)updateWithMediaAttachments:(NSArray<DDHMediaAttachment *> *)attachments imageLoader:(DDHImageLoader *)imageLoader;
- (BOOL)attachmentsVisible;
@end

NS_ASSUME_NONNULL_END
