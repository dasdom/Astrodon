//  Created by Dominik Hauser on 01.12.22.
//  
//

#import "DDHMediaAttachment.h"
#import "DDHImageDimensions.h"

@implementation DDHMediaAttachment
- (instancetype)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    _attachmentDescription = dict[@"description"];
    _attachmentId = [dict[@"id"] integerValue];

    NSString *previewURLString = dict[@"preview_url"];
    _previewURL = [NSURL URLWithString:previewURLString];

    NSString *urlString = dict[@"url"];
    _url = [NSURL URLWithString:urlString];

    NSString *typeString = dict[@"type"];
    if ([typeString isEqualToString:@"image"]) {
      _type = DDHAttachmentTypeImage;
    } else {
      _type = DDHAttachmentTypeUnknown;
    }

    NSDictionary *metaDict = dict[@"meta"];
    NSDictionary *focusDict = metaDict[@"focus"];

    _focus = CGPointMake([focusDict[@"x"] floatValue], [focusDict[@"y"] floatValue]);

    NSDictionary *originalDict = metaDict[@"original"];
    _originalDimensions = [[DDHImageDimensions alloc] initWithDictionary:originalDict];

    NSDictionary *smallDict = metaDict[@"small"];
    _smallDimensions = [[DDHImageDimensions alloc] initWithDictionary:smallDict];
  }
  return self;
}
@end
