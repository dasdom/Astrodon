//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHRequestFactory.h"
#import "DDHKeychain.h"
#import "DDHConstants.h"
#import "DDHClientKeys.h"

NSString * const apiPath = @"/api";
NSString * const version = @"/v1";
NSString * const timelines = @"/timelines";

@implementation DDHRequestFactory

+ (NSString *)pathForEndpoint:(DDHEndpoint)endpoint {
  NSString *path;
  switch (endpoint) {
    case DDHEndpointFetchToken:
      path = @"/oauth/token";
      break;
    case DDHEndpointPublic:
      path = [NSString stringWithFormat:@"%@%@%@/public", apiPath, version, timelines];
      break;
    case DDHEndpointHome:
      path = [NSString stringWithFormat:@"%@%@%@/home", apiPath, version, timelines];
    default:
      break;
  }
  return path;
}

+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint code:(NSString *)code {
  NSURLComponents *urlComponents = [NSURLComponents new];
  urlComponents.scheme = @"https";
  urlComponents.host = @"chaos.social";
  switch (endpoint) {
    case DDHEndpointFetchToken: {
      urlComponents.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"client_id" value:client_id],
        [NSURLQueryItem queryItemWithName:@"client_secret" value:client_secret],
        [NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirect_uri],
        [NSURLQueryItem queryItemWithName:@"grant_type" value:@"authorization_code"],
        [NSURLQueryItem queryItemWithName:@"code" value:code],
        [NSURLQueryItem queryItemWithName:@"scope" value:@"read+write+follow+push"],
      ];
    }
      break;
    default:
      break;
  }
  urlComponents.path = [self pathForEndpoint:endpoint];
  return [urlComponents URL];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint {
  return [self requestForEndpoint:endpoint code:nil];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint code:(NSString *)code {
  NSURL *url = [self urlForEndpoint:endpoint code:code];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  switch (endpoint) {
    case DDHEndpointFetchToken:
      request.HTTPMethod = @"POST";
    case DDHEndpointHome: {
      NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
      [request addValue:[NSString stringWithFormat:@"Bearer %@", code] forHTTPHeaderField:@"Authorization"];
    }
    default:
      break;
  }
  return request;
}

@end
