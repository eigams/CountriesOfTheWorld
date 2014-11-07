//
//  DemographicHTTPClient.m
//  RKGeonames
//
//  Created by Stefan Buretea on 4/2/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import "DemographicDataClient.h"

#import "CountryData.h"
#import "ManagedObjectStore.h"


@implementation DemographicDataClient

SingletonImplemetion(DemographicDataClient);

static NSString *const TOTAL_POPULATION_INDICATOR_STRING = @"SP.POP.TOTL";
static NSString *const POPULATION_GROWTH_INDICATOR_STRING = @"SP.POP.GROW";
static NSString *const BIRTH_RATE_INDICATOR_STRING = @"SP.DYN.CBRT.IN";
static NSString *const DEATH_RATE_INDICATOR_STRING = @"SP.DYN.CDRT.IN";
- (void) getDataForCountry:(NSString *)country
{    
    // when no data is stored locally, get it from the net
    if([self.delegate respondsToSelector:@selector(updateView:)]){
        [self.delegate updateView:self];
    }    
}


@end
