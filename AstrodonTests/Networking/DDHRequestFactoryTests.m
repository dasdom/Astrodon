//  Created by Dominik Hauser on 17.11.22.
//  
//

#import <XCTest/XCTest.h>
#import "DDHRequestFactory.h"

@interface DDHRequestFactoryTests : XCTestCase
@end

@implementation DDHRequestFactoryTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_publicURL_shouldBeAsExpected {
  NSURL *publicURL = [DDHRequestFactory urlForEndpoint:DDHEndpointPublic additionalInfo:nil];

  XCTAssertEqualObjects(publicURL, [NSURL URLWithString:@"https://chaos.social/api/v1/timelines/public"]);
}

- (void)test_tokenURL {
  NSString *code = @"EH53AYi_pCwv6hb_iFd8DJP4-Ta5IiNork-PSjXVyVo";
  NSURL *tokenURL = [DDHRequestFactory urlForEndpoint:DDHEndpointFetchToken additionalInfo:code];

  NSURLComponents *components = [[NSURLComponents alloc] initWithURL:tokenURL resolvingAgainstBaseURL:false];
  XCTAssertEqualObjects(components.scheme, @"https");
  XCTAssertEqualObjects(components.host, @"chaos.social");
  XCTAssertEqualObjects(components.path, @"/oauth/token");
  NSArray<NSURLQueryItem *> *queryItems = components.queryItems;
  XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"code" value:code]]);
}


@end
