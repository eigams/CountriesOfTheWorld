//
//  DemographicData.m
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "DemographicData.h"

@implementation DemographicData

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: initWithTotalPopulation                             |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (id)initWithTotalPopulation:(NSString *)totalPopulation
             populationGrowth:(NSString *)populationGrowth
                    birthRate:(NSString *)birthRate
                    deathRate:(NSString *)deathRate;
{
    self = [super init];
    if(self)
    {
        _totalPopulation = totalPopulation;
        _populationGrowth = populationGrowth;
        _birthRate = birthRate;
        _deathRate = deathRate;
    }
    
    return self;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: emptyDemographicData                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (id)data;
{
    return [[self alloc] initWithTotalPopulation:@"N/A"
                                           populationGrowth:@"N/A"
                                                  birthRate:@"N/A"
                                                  deathRate:@"N/A"];
    
}


@end
