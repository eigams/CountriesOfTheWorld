//
//  EconomicalDataClient.m
//  RKGeonames
//
//  Created by Stefan Buretea on 4/2/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import "EconomicalDataClient.h"

#import "ManagedObjectStore.h"
#import "CountryData.h"

@implementation EconomicalDataClient

SingletonImplemetion(EconomicalDataClient)

- (void)getDataForCountry:(NSString *)country
{
    @try
    {
        
        //
        //try to load the data from local storage
        //
        
        CountryData *countryData = (CountryData *)[[ManagedObjectStore sharedInstance] fetchItem:NSStringFromClass([CountryData class])
                                                                                       predicate:[NSPredicate predicateWithFormat:@"name == %@", country]];
        
        if(nil != countryData) {
            if([self.delegate respondsToSelector:@selector(updateView:withLocalStoredData:)]) {
                if([self.delegate updateView:self withLocalStoredData:countryData]) {
                    return;
                }
            }
        }
        
        // when no data is stored locally, get it from the net
        if([self.delegate respondsToSelector:@selector(updateView:withRemoteData:)]) {
            
            [self.delegate updateView:self withRemoteData:countryData];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Eception caught: %@", exception);
    }
}

@end
