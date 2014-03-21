//
//  CountryData.h
//  RKGeonames
//
//  Created by Stefan Buretea on 2/3/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PopulationData;

@interface CountryData : NSManagedObject

@property (nonatomic, copy) NSString * capitalCity;
@property (nonatomic, copy) NSString * currency;
@property (nonatomic, copy) NSString * east;
@property (nonatomic, copy) NSString * flagData;
@property (nonatomic, copy) NSString * iso2Code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * north;
@property (nonatomic, copy) NSString * south;
@property (nonatomic, copy) NSString * surface;
@property (nonatomic, copy) NSString * timezone;
@property (nonatomic, copy) NSString * west;
@property (nonatomic, retain) NSSet *economicalData;
@property (nonatomic, retain) NSSet *populationData;
@end

@interface CountryData (CoreDataGeneratedAccessors)

- (void)addEconomicalDataObject:(NSManagedObject *)value;
- (void)removeEconomicalDataObject:(NSManagedObject *)value;
- (void)addEconomicalData:(NSSet *)values;
- (void)removeEconomicalData:(NSSet *)values;

- (void)addPopulationDataObject:(PopulationData *)value;
- (void)removePopulationDataObject:(PopulationData *)value;
- (void)addPopulationData:(NSSet *)values;
- (void)removePopulationData:(NSSet *)values;

@end
