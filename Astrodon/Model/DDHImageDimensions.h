//  Created by Dominik Hauser on 01.12.22.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHImageDimensions : NSObject
@property CGFloat aspect;
@property NSInteger height;
@property NSInteger width;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
