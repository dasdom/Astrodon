//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>

@class DDHAccount;
@class DDHMediaAttachment;
@class DDHQuote;

NS_ASSUME_NONNULL_BEGIN

@interface DDHToot : NSObject
@property (strong) NSString *statusId;
@property (strong) DDHAccount *account;
@property (strong) NSString *content;
@property (strong) NSDate *createdAt;
@property (strong) NSString *language;
@property (strong) NSString *spoilerText;
@property (strong) NSArray<DDHMediaAttachment *> *mediaAttachments;
@property (nullable, strong) DDHToot *boostedToot;
@property (nullable, strong) DDHQuote *quote;
@property BOOL sensitive;
@property BOOL showsSensitive;
@property BOOL reblogged;
@property BOOL favourited;
- (instancetype)initWithDictionary:(NSDictionary *)dict dateFormatter:(NSISO8601DateFormatter *)dateFormatter;
- (BOOL)isBoost;
@end

NS_ASSUME_NONNULL_END
