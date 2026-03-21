//  Created by Dominik Hauser on 18.01.26.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHMention : NSObject
@property (strong) NSString *mentionId;
@property (strong) NSString *userName;
@property (strong) NSString *urlString;
@property (strong) NSString *acct;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
