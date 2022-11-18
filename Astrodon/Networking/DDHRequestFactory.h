//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHEndpoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHRequestFactory : NSObject
+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint;
+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint;
@end

NS_ASSUME_NONNULL_END
