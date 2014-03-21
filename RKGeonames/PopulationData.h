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

@property (nonatomic, copy) NSString * birthRate;
@property (nonatomic, copy) NSString * deathRate;
@property (nonatomic, copy) NSString * growth;
@property (nonatomic, copy) NSString * total;
@property (nonatomic, copy) NSString * year;
@property (nonatomic, retain) CountryData *countryData;

@end
