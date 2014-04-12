//
//  DemographicDataClient.h
//  RKGeonames
//
//  Created by Stefan Buretea on 4/2/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@class DemographicDataClient;
@class CountryData;

@protocol DemographicDataClientDelegate <NSObject>

@optional
- (BOOL)updateView:(DemographicDataClient *)client withLocalStoredData:(CountryData *)countryData;
- (BOOL)updateView:(DemographicDataClient *)client withRemoteData:(CountryData *)countryData;

@end

@interface DemographicDataClient : NSObject

@property (nonatomic, weak) id<DemographicDataClientDelegate> delegate;

SingletonInterface(DemographicDataClient)

- (void)getDataForCountry:(NSString *)country;

@end
