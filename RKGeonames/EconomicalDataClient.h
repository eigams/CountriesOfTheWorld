//
//  EconomicalDataClient.h
//  RKGeonames
//
//  Created by Stefan Buretea on 4/2/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@class EconomicalDataClient;
@class CountryData;

@protocol EconomicalDataClientDelegate <NSObject>

@optional
- (BOOL)updateView:(EconomicalDataClient *)client withLocalStoredData:(CountryData *)countryData;
- (BOOL)updateView:(EconomicalDataClient *)client withRemoteData:(CountryData *)countryData;

@end

@interface EconomicalDataClient : NSObject

@property (nonatomic, weak) id<EconomicalDataClientDelegate> delegate;

SingletonInterface(EconomicalDataClient)

- (void)getDataForCountry:(NSString *)country;

@end
