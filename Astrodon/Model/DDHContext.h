//  Created by Dominik Hauser on 29.03.26.
//  
//


#import <Foundation/Foundation.h>

@class DDHToot;

NS_ASSUME_NONNULL_BEGIN

@interface DDHContext : NSObject
@property (strong) NSArray<DDHToot *> *ancestors;
@property (strong) NSArray<DDHToot *> *descendants;
- (instancetype)initWithDictionary:(NSDictionary *)dict dataFormatter:(NSISO8601DateFormatter *)dateFormatter;
@end

NS_ASSUME_NONNULL_END
