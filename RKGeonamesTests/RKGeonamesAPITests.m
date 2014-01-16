//
//  RKGeonamesAPITests.m
//  RKGeonames
//
//  Created by Stefan Buretea on 12/9/13.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGeonamesUtils.h"
#import "GHUnit.h"

@interface RKGeonamesAPITests : GHAsyncTestCase

@end

@implementation RKGeonamesAPITests

static const float kNetworkTimeout = 30.0f;
static NSString * const GDP_INDICATOR_STRING = @"NY.GDP.MKTP.CD";
static const int TYPE_FLOAT = 1;
static const UniChar dollar = 0x0024;

- (void)testFetchWorldBankIndicator
{
    [self prepare];
    
    __block NSError     *responseError      = nil;
    __block NSString    *outValue = nil;
    
    [RKGeonamesUtils fetchWorldBankIndicator:GDP_INDICATOR_STRING
                              forCountryCode:@"RO"
                                    withType:TYPE_FLOAT
                                     andText:[NSString stringWithFormat:@" %C", dollar]
                              withCompletion:^(NSString *Data){
                                  
                                        outValue = Data;
                                  
                                        [self notify:kGHUnitWaitStatusSuccess forSelector:_cmd];
                                     }
                                     failure:^{
                                         responseError = [NSError errorWithDomain:@"fetchWorldIndicatorType" code:0xf00 userInfo:nil];
                                     }];
    
    // Wait for the async activity to complete
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kNetworkTimeout];
    
    // Check for Observation Object &amp; Error
    GHAssertNil(responseError, @"");
    GHAssertNotNil(outValue, @"outValue is nil");
    
}

@end
