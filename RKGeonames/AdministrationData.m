//
//  AdministrationData.m
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "AdministrationData.h"

@implementation AdministrationData


// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: initWithCapitalCity                                 |+|
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
- (id)initWithCapitalCity:(NSString *)capitalCity
                  surface:(NSString *)surface
              currentTime:(NSString *)currentTime
                 timeZone:(NSString *)timeZone
                  sunrise:(NSString *)sunrise
                   sunset:(NSString *)sunset
{
    self = [super init];
    if(self)
    {
        _capitalCity = capitalCity;
        _surface = surface;
        _currentTime = currentTime;
        _timeZone = timeZone;
        _sunrise = sunrise;
        _sunset = sunset;
    }
    
    return self;
}

+ (id)data;
{
    return [[self alloc] initWithCapitalCity:@"N/A"
                                   surface:@"N/A"
                               currentTime:@"N/A"
                                  timeZone:@"N/A"
                                   sunrise:@"N/A"
                                    sunset:@"N/A"];

}

@end
