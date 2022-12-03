//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>

@class DDHAccount;
@class DDHMediaAttachment;

NS_ASSUME_NONNULL_BEGIN

@interface DDHToot : NSObject
@property (strong) DDHAccount *account;
@property (strong) NSString *content;
@property (strong) NSDate *createdAt;
@property BOOL sensitive;
@property BOOL showsSensitive;
@property (strong) NSString *spoilerText;
@property (strong) NSArray<DDHMediaAttachment *> *mediaAttachments;
@property (strong) DDHToot *boostedToot;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (BOOL)isBoost;
@end

NS_ASSUME_NONNULL_END
