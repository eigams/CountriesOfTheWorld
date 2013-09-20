//
//  DemographicData.h
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemographicData : NSObject

@property (nonatomic, copy, readonly) NSString *totalPopulation, *populationGrowth, *birthRate, *deathRate;

- (id)initWithTotalPopulation:(NSString *)totalPopulation
             populationGrowth:(NSString *)populationGrowth
                    birthRate:(NSString *)birthRate
                    deathRate:(NSString *)deathRate;

@end
