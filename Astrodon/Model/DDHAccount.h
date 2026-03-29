//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHAccount : NSObject
@property (strong) NSString *displayName;
@property (strong) NSString *acct;
@property (strong) NSString *accountId;
@property (strong) NSURL *avatarURL;
@property (strong) NSURL *headerURL;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
