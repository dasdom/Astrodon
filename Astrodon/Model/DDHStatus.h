//  Created by Dominik Hauser on 29.12.25.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHStatus : NSObject
@property (nonatomic, strong) NSString *text;
- (instancetype)initWithText:(NSString *)text;
- (NSData *)data;
@end

NS_ASSUME_NONNULL_END
