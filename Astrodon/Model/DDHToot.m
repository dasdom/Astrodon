//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHToot.h"
#import "DDHAccount.h"
#import "DDHMediaAttachment.h"
#import "DDHQuote.h"

@implementation DDHToot
- (instancetype)initWithDictionary:(NSDictionary *)dict dateFormatter:(NSISO8601DateFormatter *)dateFormatter {
  if (self = [super init]) {
    _content = dict[@"content"];

    NSDictionary *accountDict = dict[@"account"];
    _account = [[DDHAccount alloc] initWithDictionary:accountDict];

    _sensitive = [dict[@"sensitive"] boolValue];
    _reblogged = [dict[@"reblogged"] boolValue];
    _favourited = [dict[@"favourited"] boolValue];

    _createdAt = [dateFormatter dateFromString:dict[@"created_at"]];
    _language = dict[@"language"];
    _spoilerText = dict[@"spoiler_text"];

    _statusId = dict[@"id"];

    NSMutableArray<DDHMediaAttachment *> *mediaAttachments = [NSMutableArray new];
    NSArray<NSDictionary *> *rawMediaAttachments = dict[@"media_attachments"];
    [rawMediaAttachments enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull rawAttachment, NSUInteger idx, BOOL * _Nonnull stop) {
      DDHMediaAttachment *attachment = [[DDHMediaAttachment alloc] initWithDictionary:rawAttachment];
      [mediaAttachments addObject:attachment];
    }];
    _mediaAttachments = mediaAttachments;

    NSDictionary *reblogDict = dict[@"reblog"];
    if ([reblogDict isKindOfClass:[NSDictionary class]]) {
      _boostedToot = [[DDHToot alloc] initWithDictionary:reblogDict dateFormatter:dateFormatter];
    }

    NSDictionary *quoteDict = dict[@"quote"];
    if ([quoteDict isKindOfClass:[NSDictionary class]]) {
      _quote = [[DDHQuote alloc] initWithDictionary:quoteDict dateFormatter:dateFormatter];
    }
  }
  return self;
}

- (BOOL)isBoost {
  return self.boostedToot;
}

@end
