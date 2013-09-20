//
//  AdministrationData+TableRepresentation.m
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "AdministrationData+TableRepresentation.h"

@implementation AdministrationData (TableRepresentation)


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
    return @{@"titles":@[@"Capital", @"Surface", @"CurrentTime", @"TimeZone", @"Sunrise", @"Sunset"],
             @"values":@[self.capitalCity, self.surface, self.currentTime, self.timeZone, self.sunrise, self.sunset]};
}

@end
