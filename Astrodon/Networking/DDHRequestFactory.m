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
NSString * const accounts = @"/accounts";

@implementation DDHRequestFactory

+ (NSString *)pathForEndpoint:(DDHEndpoint)endpoint subPath:(NSString *)subPath {
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
      path = [NSString stringWithFormat:@"%@%@%@/%@/reblog", apiPath, version, statuses, subPath];
      break;
    case DDHEndpointFavorite:
      path = [NSString stringWithFormat:@"%@%@%@/%@/favourite", apiPath, version, statuses, subPath];
      break;
    case DDHEndpointAccount:
      path = [NSString stringWithFormat:@"%@%@%@/%@", apiPath, version, accounts, subPath];
      break;
    case DDHEndpointContext:
      path = [NSString stringWithFormat:@"%@%@%@/%@/context", apiPath, version, statuses, subPath];
      break;
  }
  return path;
}

+ (NSURL *)urlForEndpoint:(DDHEndpoint)endpoint subPath:(NSString *)subPath queryItemsDictionary:(NSDictionary<NSString *, NSString *> *)queryItemsDictionary {
  NSURLComponents *urlComponents = [NSURLComponents new];
  urlComponents.scheme = @"https";
  urlComponents.host = @"chaos.social";
  NSMutableArray<NSURLQueryItem *> *queryItems = [[NSMutableArray alloc] init];
  switch (endpoint) {
    case DDHEndpointFetchToken: {
      [queryItems addObjectsFromArray:@[
        [NSURLQueryItem queryItemWithName:@"client_id" value:client_id],
        [NSURLQueryItem queryItemWithName:@"client_secret" value:client_secret],
        [NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirect_uri],
        [NSURLQueryItem queryItemWithName:@"grant_type" value:@"authorization_code"],
        [NSURLQueryItem queryItemWithName:@"scope" value:@"read+write+follow+push"],
      ]];
      break;
    }
    default:
      break;
  }
  for (NSString *key in queryItemsDictionary.allKeys) {
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:queryItemsDictionary[key]];
    [queryItems addObject:queryItem];
  }
  urlComponents.queryItems = [queryItems copy];
  urlComponents.path = [self pathForEndpoint:endpoint subPath:subPath];
  return [urlComponents URL];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint {
  return [self requestForEndpoint:endpoint subPath:nil queryItemsDictionary:nil];
}

+ (NSURLRequest *)requestForEndpoint:(DDHEndpoint)endpoint subPath:(NSString *)subPath queryItemsDictionary:(NSDictionary<NSString *, NSString *> *)queryItemsDictionary {
  NSURL *url = [self urlForEndpoint:endpoint subPath:subPath queryItemsDictionary:queryItemsDictionary];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  switch (endpoint) {
    case DDHEndpointFetchToken:
      request.HTTPMethod = @"POST";
      break;
    case DDHEndpointPublic:
      break;
    case DDHEndpointHome:
    case DDHEndpointAccount:
    case DDHEndpointContext: {
      NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
      [request addValue:[NSString stringWithFormat:@"Bearer %@", code] forHTTPHeaderField:@"Authorization"];
      break;
    }
    case DDHEndpointNewStatus:
    case DDHEndpointBoost:
    case DDHEndpointFavorite:
    {
      NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
      [request addValue:[NSString stringWithFormat:@"Bearer %@", code] forHTTPHeaderField:@"Authorization"];
      [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
      [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      request.HTTPMethod = @"POST";
      break;
    }
  }
  return request;
}

@end
