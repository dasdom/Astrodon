//  Created by Dominik Hauser on 01.12.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHImageDimensions.h"

typedef NS_ENUM(NSInteger, DDHAttachmentType) {
  DDHAttachmentTypeUnknown,
  DDHAttachmentTypeImage
};

NS_ASSUME_NONNULL_BEGIN

@interface DDHMediaAttachment : NSObject
@property DDHAttachmentType type;
@property (strong) NSString *attachmentDescription;
@property NSInteger attachmentId;
@property (strong) NSURL *previewURL;
@property (strong) NSURL *url;
@property CGPoint focus;
@property (strong) DDHImageDimensions *originalDimensions;
@property (strong) DDHImageDimensions *smallDimensions;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
