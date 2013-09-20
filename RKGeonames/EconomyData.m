//
//  EconomyData.m
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "EconomyData.h"

@implementation EconomyData

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: initWithCurrency                                    |+|
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
- (id)initWithCurrency:(NSString *)currency
                   gdp:(NSString *)gdp
                 gdppc:(NSString *)gdppc
                 gnipc:(NSString *)gnipc;
{
    self = [super init];
    if(self)
    {
        _currency = currency;
        _gdp = gdp;
        _gdppc = gdppc;
        _gnipc = gnipc;
    }
    
    return self;
}

@end
