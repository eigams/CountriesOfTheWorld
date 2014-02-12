//
//  PopulationData.h
//  RKGeonames
//
//  Created by Stefan Buretea on 2/3/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountryData;

@interface PopulationData : NSManagedObject

@property (nonatomic, retain) NSString * birthRate;
@property (nonatomic, retain) NSString * deathRate;
@property (nonatomic, retain) NSString * growth;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) CountryData *countryData;

@end
