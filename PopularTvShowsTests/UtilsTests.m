//
//  UtilsTests.m
//  PopularTvShows
//
//  Created by Edmilson Neto on 21/01/17.
//  Copyright © 2017 Edmilson Neto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utils.h"

@interface UtilsTests : XCTestCase

@end

@implementation UtilsTests {
    NSString *correctApiKey;
    NSString *correctServiceUrl;
}

- (void)setUp {
    [super setUp];
    
    correctApiKey = @"814a8e000a55aef7cd311f1390b1e97d";
    correctServiceUrl = @"https://api.themoviedb.org";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCorrectApiKey {
    XCTAssertEqual([Utils ApiKey], correctApiKey);
}

- (void)testCorrectServiceUrl {
    XCTAssertEqual([Utils ServiceUrl], correctServiceUrl);
}

@end
