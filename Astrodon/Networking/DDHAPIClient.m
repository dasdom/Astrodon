//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHAPIClient.h"
#import "DDHToot.h"
#import "DDHAccount.h"
#import "DDHRequestFactory.h"
#import "DDHErrorCodes.h"

@interface DDHAPIClient ()
@property (strong) NSURLSession *session;
@end

@implementation DDHAPIClient

- (instancetype)init {
  if (self = [super init]) {
    _session = [NSURLSession sharedSession];
  }
  return self;
}

- (void)fetchTokenWithCode:(NSString *)code completionHandler:(void(^)(NSString *token, NSError *error))completionHandler {

  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointFetchToken code:code];
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    NSError *requestError = [self errorFromData:data response:response error:error];
    if (requestError) {
      completionHandler(nil, requestError);
      return;
    }

    NSError *jsonError = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSString *token = dict[@"access_token"];
    completionHandler(token, nil);
  }];

  [dataTask resume];
}

- (void)timelineFromEndpoint:(DDHEndpoint)endpoint completionHandler:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler {

  if (endpoint != DDHEndpointPublic && endpoint != DDHEndpointHome) {
    return;
  }
  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:endpoint];
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    NSError *requestError = [self errorFromData:data response:response error:error];
    if (requestError) {
      completionHandler(nil, requestError);
      return;
    }

    NSError *jsonError = nil;
    NSArray<NSDictionary *> *rawArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSMutableArray *toots = [NSMutableArray new];
    [rawArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
      NSLog(@"dict: %@", dict);
      DDHToot *toot = [[DDHToot alloc] initWithDictionary:dict];
      [toots addObject:toot];
    }];

    completionHandler(toots, nil);
  }];

  [dataTask resume];
}

- (NSError *)errorFromData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
  if (error) {
    return error;
  }

  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode != 200) {
    NSError *responseError = [[NSError alloc] initWithDomain:@"DDHAPIClientErrorDomain" code:DDHErrorCodeResponseNotOK userInfo:nil];
    return responseError;
  }

  if (data == nil) {
    NSError *responseError = [[NSError alloc] initWithDomain:@"DDHAPIClientErrorDomain" code:DDHErrorCodeDataEmpty userInfo:nil];
    return responseError;
  }

  return nil;
}

@end
