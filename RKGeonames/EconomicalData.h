//
//  EconomicalData.h
//  RKGeonames
//
//  Created by Stefan Buretea on 2/3/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountryData;

@interface EconomicalData : NSManagedObject

@property (nonatomic, retain) NSString * gdp;
@property (nonatomic, retain) NSString * gdppercapita;
@property (nonatomic, retain) NSString * gnipercapita;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) CountryData *countryData;

@end
