//  Created by Dominik Hauser on 30.03.26.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Extensions)
- (NSArray *)map:(id (^)(id element))block;
@end

NS_ASSUME_NONNULL_END
