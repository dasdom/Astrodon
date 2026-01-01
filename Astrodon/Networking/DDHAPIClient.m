//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHAPIClient.h"
#import "DDHToot.h"
#import "DDHStatus.h"
#import "DDHAccount.h"
#import "DDHRequestFactory.h"
#import "DDHErrorCodes.h"
#import <OSLog/OSLog.h>

@interface DDHAPIClient ()
@property (strong) NSURLSession *session;
@property (strong) NSISO8601DateFormatter *dateFormatter;
@end

@implementation DDHAPIClient

- (instancetype)init {
  if (self = [super init]) {
    _session = [NSURLSession sharedSession];
    _dateFormatter = [[NSISO8601DateFormatter alloc] init];
    _dateFormatter.formatOptions = _dateFormatter.formatOptions | NSISO8601DateFormatWithFractionalSeconds;
  }
  return self;
}

- (void)fetchTokenWithCode:(NSString *)code completionHandler:(void(^)(NSString *token, NSError *error))completionHandler {

  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointFetchToken additionalInfo:code];
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
    typeof(self) __weak weakSelf = self;
    [rawArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
      os_log(OS_LOG_DEFAULT, "dict: %@", dict);
      DDHToot *toot = [[DDHToot alloc] initWithDictionary:dict dateFormatter:weakSelf.dateFormatter];
      [toots addObject:toot];
    }];

    completionHandler(toots, nil);
  }];

  [dataTask resume];
}

- (void)postNewStatus:(DDHStatus *)status completionHandler:(void(^)(NSError *error))completionHandler {
  NSMutableURLRequest *request = [[DDHRequestFactory requestForEndpoint:DDHEndpointNewStatus] mutableCopy];
  request.HTTPBody = status.data;
  [self executeRequest:request completionHandler:^(NSError *error) {
    completionHandler(error);
  }];
}

- (void)boostStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler {
  NSMutableURLRequest *request = [[DDHRequestFactory requestForEndpoint:DDHEndpointBoost additionalInfo:statusId] mutableCopy];
  [self executeRequest:request completionHandler:^(NSError *error) {
    completionHandler(error);
  }];
}

- (void)executeRequest:(NSURLRequest *)request completionHandler:(void(^)(NSError *error))completionHandler {
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSError *requestError = [self errorFromData:data response:response error:error];
    if (requestError) {
      completionHandler(requestError);
      return;
    }
    completionHandler(nil);
  }];

  [dataTask resume];
}

// MARK: - Error helper
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
