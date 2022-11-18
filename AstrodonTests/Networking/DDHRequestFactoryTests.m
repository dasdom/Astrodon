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
  NSURL *publicURL = [DDHRequestFactory urlForEndpoint:DDHEndpointPublic];

  XCTAssertEqualObjects(publicURL, [NSURL URLWithString:@"https://chaos.social/api/v1/timelines/public"]);
}


@end
