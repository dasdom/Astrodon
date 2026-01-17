//  Created by Dominik Hauser on 29.12.25.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHStatus : NSObject
@property (strong) NSString *text;
@property (strong) NSString *inReplyToId;
- (instancetype)initWithText:(NSString *)text inReplyToId:(nullable NSString *)inReplyToId;
- (NSData *)data;
@end

NS_ASSUME_NONNULL_END
