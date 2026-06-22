//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHAPIClient.h"
#import "DDHToot.h"
#import "DDHStatus.h"
#import "DDHAccount.h"
#import "DDHRelationship.h"
#import "DDHContext.h"
#import "DDHRequestFactory.h"
#import "DDHErrorCodes.h"
#import <OSLog/OSLog.h>

@interface DDHAPIClient ()
@property (strong) NSURLSession *session;
@property (strong) NSISO8601DateFormatter *dateFormatter;
@property BOOL fetchingToots;
@property (strong) NSURL *lastRequestURL;
@end

@implementation DDHAPIClient

- (instancetype)init {
  if (self = [super init]) {
    _session = [NSURLSession sharedSession];
    _dateFormatter = [[NSISO8601DateFormatter alloc] init];
    _dateFormatter.formatOptions = _dateFormatter.formatOptions | NSISO8601DateFormatWithFractionalSeconds;
    _fetchingToots = NO;
  }
  return self;
}

- (void)fetchTokenWithCode:(NSString *)code completionHandler:(void(^)(NSString *token, NSError *error))completionHandler {

  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointFetchToken subPath:nil queryItemsDictionary:@{@"code" : code}];
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

- (void)homeTimelineSinceToot:(DDHToot *)toot completionHander:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler {
  NSDictionary<NSString *, NSString *> *queryItemsDictionary = nil;
  if (toot) {
    queryItemsDictionary = @{@"since_id": toot.statusId};
  }
  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointHome subPath:nil queryItemsDictionary:queryItemsDictionary];

  [self executeRequest:request tootsCompletionHandler:completionHandler];
}

- (void)homeTimelineBeforeToot:(DDHToot *)toot completionHander:(void (^)(NSArray<DDHToot *> * _Nonnull, NSError * _Nonnull))completionHandler {
  NSDictionary<NSString *, NSString *> *queryItemsDictionary = nil;
  if (toot) {
    queryItemsDictionary = @{@"max_id": toot.statusId};
  }
  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointHome subPath:nil queryItemsDictionary:queryItemsDictionary];

  [self executeRequest:request tootsCompletionHandler:completionHandler];
}

- (void)postNewStatus:(DDHStatus *)status completionHandler:(void(^)(NSError *error))completionHandler {
  NSMutableURLRequest *request = [[DDHRequestFactory requestForEndpoint:DDHEndpointNewStatus] mutableCopy];
  request.HTTPBody = status.data;
  [self executeRequest:request completionHandler:^(NSError *error) {
    completionHandler(error);
  }];
}

- (void)boostStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler {
  NSMutableURLRequest *request = [[DDHRequestFactory requestForEndpoint:DDHEndpointBoost subPath:statusId queryItemsDictionary:nil] mutableCopy];
  [self executeRequest:request completionHandler:^(NSError *error) {
    completionHandler(error);
  }];
}

- (void)favoriteStatusWithId:(NSString *)statusId completionHandler:(void(^)(NSError *error))completionHandler {
  NSMutableURLRequest *request = [[DDHRequestFactory requestForEndpoint:DDHEndpointFavorite subPath:statusId queryItemsDictionary:nil] mutableCopy];
  [self executeRequest:request completionHandler:^(NSError *error) {
    completionHandler(error);
  }];
}

//- (void)accountForId:(NSString *)accountId completionHandler:(void(^)(DDHAccount *account, NSError *error))completionHandler {
//  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointAccount subPath:accountId queryItemsDictionary:nil];
//  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//    NSError *requestError = [self errorFromData:data response:response error:error];
//    if (requestError) {
//      completionHandler(nil, requestError);
//      return;
//    }
//
//    NSError *jsonError = nil;
//    NSDictionary *rawDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//    os_log(OS_LOG_DEFAULT, "dict: %@", rawDictionary);
//    DDHAccount *account = [[DDHAccount alloc] initWithDictionary:rawDictionary];
//
//    completionHandler(account, nil);
//  }];
//
//  [dataTask resume];
//}

- (void)relationshipForId:(NSString *)accountId completionHandler:(void(^)(DDHRelationship *relationship, NSError *error))completionHandler {
  NSDictionary<NSString *, NSString *> *queryItemsDictionary = @{@"id[]": accountId};
  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointRelationship subPath:nil queryItemsDictionary:queryItemsDictionary];
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    NSError *requestError = [self errorFromData:data response:response error:error];
    if (requestError) {
      completionHandler(nil, requestError);
      return;
    }

    NSError *jsonError = nil;
    NSArray *rawArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    os_log(OS_LOG_DEFAULT, "array: %@", rawArray);
    DDHRelationship *relationship = [[DDHRelationship alloc] initWithDictionary:rawArray.firstObject];

    completionHandler(relationship, nil);
  }];

  [dataTask resume];
}

- (void)contextForId:(NSString *)statusId completionHandler:(void(^)(DDHContext *context, NSError *error))completionHandler {
  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointContext subPath:statusId queryItemsDictionary:nil];
  typeof(self) __weak weakSelf = self;
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    NSError *requestError = [weakSelf errorFromData:data response:response error:error];
    if (requestError) {
      completionHandler(nil, requestError);
      return;
    }

    NSError *jsonError = nil;
    NSDictionary *rawDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    os_log(OS_LOG_DEFAULT, "dict: %@", rawDictionary);
    DDHContext *context = [[DDHContext alloc] initWithDictionary:rawDictionary dataFormatter:weakSelf.dateFormatter];
    completionHandler(context, nil);
  }];

  [dataTask resume];
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

- (void)executeRequest:(NSURLRequest *)request tootsCompletionHandler:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler {

  if (self.lastRequestURL) {
    if ([[request URL] isEqualTo:self.lastRequestURL]) {
      os_log(OS_LOG_DEFAULT, "skipping because repetition %@", self.lastRequestURL);
      completionHandler(@[], nil);
      return;
    }
  }
  self.lastRequestURL = [request URL];
  os_log(OS_LOG_DEFAULT, "request %@", self.lastRequestURL);

  typeof(self) __weak weakSelf = self;
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    NSError *requestError = [weakSelf errorFromData:data response:response error:error];
    if (requestError) {
      completionHandler(nil, requestError);
      weakSelf.fetchingToots = NO;
      return;
    }

    NSError *jsonError = nil;
    NSArray<NSDictionary *> *rawArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSMutableArray *toots = [NSMutableArray new];

    if ([toots count] < 1) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.lastRequestURL = nil;
      });
    }
    [rawArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
      os_log(OS_LOG_DEFAULT, "dict: %@", dict);
      DDHToot *toot = [[DDHToot alloc] initWithDictionary:dict dateFormatter:weakSelf.dateFormatter];
      [toots addObject:toot];
    }];

    completionHandler(toots, nil);
    weakSelf.fetchingToots = NO;
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
    NSError *responseError = [[NSError alloc] initWithDomain:@"DDHAPIClientErrorDomain" code:httpResponse.statusCode userInfo:nil];
    return responseError;
  }

  if (data == nil) {
    NSError *responseError = [[NSError alloc] initWithDomain:@"DDHAPIClientErrorDomain" code:DDHErrorCodeDataEmpty userInfo:nil];
    return responseError;
  }

  return nil;
}

@end
