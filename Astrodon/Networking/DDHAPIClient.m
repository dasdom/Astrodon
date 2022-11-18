//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHAPIClient.h"
#import "DDHToot.h"
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

- (void)publicTimeline:(void(^)(NSArray<DDHToot *> *toots, NSError *error))completionHandler {
  NSURLRequest *request = [DDHRequestFactory requestForEndpoint:DDHEndpointPublic];
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    if (error) {
      completionHandler(nil, error);
      return;
    }

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode != 200) {
      NSError *responseError = [[NSError alloc] initWithDomain:@"DDHAPIClientErrorDomain" code:DDHErrorCodeResponseNotOK userInfo:nil];
      completionHandler(nil, responseError);
      return;
    }

    if (data == nil) {
      NSError *responseError = [[NSError alloc] initWithDomain:@"DDHAPIClientErrorDomain" code:DDHErrorCodeDataEmpty userInfo:nil];
      completionHandler(nil, responseError);
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

@end
