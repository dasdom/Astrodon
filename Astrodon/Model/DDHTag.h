//  Created by Dominik Hauser on 29.06.26.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHTag : NSObject
@property (strong) NSString *name;
@property (strong) NSString *urlString;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
