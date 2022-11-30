//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>

@class DDHAccount;

NS_ASSUME_NONNULL_BEGIN

@interface DDHToot : NSObject
@property (strong) DDHAccount *account;
@property (strong) NSString *content;
@property (strong) NSDate *createdAt;
@property BOOL sensitive;
@property (strong) NSString *spoilerText;
@property (strong) DDHToot *boostedToot;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (BOOL)isBoost;
@end

NS_ASSUME_NONNULL_END
