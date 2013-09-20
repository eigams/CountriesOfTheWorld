//
//  EconomyData+TableRepresentation.m
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "EconomyData+TableRepresentation.h"

@implementation EconomyData (TableRepresentation)

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
    return @{@"titles":@[@"Currency", @"GDP", @"GDP per Capita", @"GNI per Capita"],
             @"values":@[self.currency, self.gdp, self.gdppc, self.gnipc]};
}


@end
