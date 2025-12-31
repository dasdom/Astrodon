//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <Foundation/Foundation.h>
#import "DDHEndpoint.h"

@interface DDHRequestFactory : NSObject
+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint additionalInfo:(NSString *)code;
+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint;
+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint additionalInfo:(NSString *)additionalInfo;
@end
