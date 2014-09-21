//
//  CountryData.h
//  RKGeonames
//
//  Created by Stefan Buretea on 9/21/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EconomicalData, PopulationData;

@interface CountryData : NSManagedObject

@property (nonatomic, retain) NSString * capitalCity;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * east;
@property (nonatomic, retain) NSString * flagData;
@property (nonatomic, retain) NSString * iso2Code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * north;
@property (nonatomic, retain) NSString * south;
@property (nonatomic, retain) NSString * surface;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * west;
@property (nonatomic, retain) NSSet *economicalData;
@property (nonatomic, retain) NSSet *populationData;
@end

@interface CountryData (CoreDataGeneratedAccessors)

- (void)addEconomicalDataObject:(EconomicalData *)value;
- (void)removeEconomicalDataObject:(EconomicalData *)value;
- (void)addEconomicalData:(NSSet *)values;
- (void)removeEconomicalData:(NSSet *)values;

- (void)addPopulationDataObject:(PopulationData *)value;
- (void)removePopulationDataObject:(PopulationData *)value;
- (void)addPopulationData:(NSSet *)values;
- (void)removePopulationData:(NSSet *)values;

@end
