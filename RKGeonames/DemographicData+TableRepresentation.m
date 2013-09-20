//
//  DemographicData+TableRepresentation.m
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "DemographicData+TableRepresentation.h"

@implementation DemographicData (TableRepresentation)

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: tr_tableRepresentation                              |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (NSDictionary *)tr_tableRepresentation
{
    return @{@"titles":@[@"Total Population", @"Population Growth", @"Birth Rate", @"Death Rate"],
             @"values":@[self.totalPopulation, self.populationGrowth, self.birthRate, self.deathRate]};
}


@end
