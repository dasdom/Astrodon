//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHEndpoint.h"

@interface DDHRequestFactory : NSObject
+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint code:(NSString *)code;
+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint;
+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint code:(NSString *)code;
@end
