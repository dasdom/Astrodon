//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHRequestFactory.h"

@implementation DDHRequestFactory
+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint {
  NSString *path = @"/api/v1/timelines/";
  switch (endpoint) {
    case DDHEndpointPublic:
      path = [path stringByAppendingString:@"public"];
      break;

    default:
      break;
  }
  NSURLComponents *urlComponents = [NSURLComponents new];
  urlComponents.scheme = @"https";
  urlComponents.host = @"chaos.social";
  urlComponents.path = path;
  return [urlComponents URL];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint {
  NSURL *url = [self urlForEndpoint:endpoint];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  switch (endpoint) {
    default:
      break;
  }
  return request;
}
@end
