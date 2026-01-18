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
NSString * const statuses = @"/statuses";

@implementation DDHRequestFactory

+ (NSString *)pathForEndpoint:(DDHEndpoint)endpoint additionalInfo:(NSString *)additionalInfo {
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
      break;
    case DDHEndpointNewStatus:
      path = [NSString stringWithFormat:@"%@%@%@", apiPath, version, statuses];
      break;
    case DDHEndpointBoost:
      path = [NSString stringWithFormat:@"%@%@%@/%@/reblog", apiPath, version, statuses, additionalInfo];
      break;
    case DDHEndpointFavorite:
      path = [NSString stringWithFormat:@"%@%@%@/%@/favourite", apiPath, version, statuses, additionalInfo];
      break;
  }
  return path;
}

+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint additionalInfo:(NSString *)additionalInfo {
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
        [NSURLQueryItem queryItemWithName:@"code" value:additionalInfo],
        [NSURLQueryItem queryItemWithName:@"scope" value:@"read+write+follow+push"],
      ];
    }
      break;
    default:
      break;
  }
  urlComponents.path = [self pathForEndpoint:endpoint additionalInfo:additionalInfo];
  return [urlComponents URL];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint {
  return [self requestForEndpoint:endpoint additionalInfo:nil];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint additionalInfo:(NSString *)additionalInfo {
  NSURL *url = [self urlForEndpoint:endpoint additionalInfo:additionalInfo];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  switch (endpoint) {
    case DDHEndpointFetchToken:
      request.HTTPMethod = @"POST";
      break;
    case DDHEndpointPublic:
      break;
    case DDHEndpointHome: {
      NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
      [request addValue:[NSString stringWithFormat:@"Bearer %@", code] forHTTPHeaderField:@"Authorization"];
    }
      break;
    case DDHEndpointNewStatus:
    case DDHEndpointBoost:
    case DDHEndpointFavorite:
    {
      NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
      [request addValue:[NSString stringWithFormat:@"Bearer %@", code] forHTTPHeaderField:@"Authorization"];
      [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
      [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      request.HTTPMethod = @"POST";
    }
      break;
  }
  return request;
}

@end
