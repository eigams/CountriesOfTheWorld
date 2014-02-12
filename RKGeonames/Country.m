//
//  Country.m
//  RKGeonames
//
//  Created by Stefan Burettea on 22/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "Country.h"
#import "CountryData.h"

@implementation CountryInfo

@synthesize countries;

@end

@implementation PageInfo

@synthesize page;
@synthesize pages;
@synthesize per_page;
@synthesize total;

@end

@implementation RKCountry

@synthesize id;
@synthesize iso2Code;
@synthesize name;
@synthesize region;
@synthesize adminregion;
@synthesize incomeLevel;
@synthesize lendingType;
@synthesize capitalCity;
@synthesize longitude;
@synthesize latitude;

@end

@implementation Region

@synthesize id;
@synthesize value;

@end

@implementation AdminRegion

@synthesize id;
@synthesize value;

@end

@implementation IncomeLevel

@synthesize id;
@synthesize value;

@end

@implementation LendingType

@synthesize id;
@synthesize value;

@end

@implementation CountryGeonames

@synthesize name;
@synthesize currency;
@synthesize fipsCode;
@synthesize countryCode;
@synthesize isoNumeric;
@synthesize north;
@synthesize capitalCity;
@synthesize continentName;
@synthesize areaInSqKm;
@synthesize languages;
@synthesize isoAlpha3;
@synthesize continent;
@synthesize south;
@synthesize east;
@synthesize geonameId;
@synthesize west;
@synthesize population;

- (id)initWithManagedObject:(CountryData *)model
{
    self = [super init];
    
    if (self) {
        self.name = model.name;
        self.currency = model.currency;
        self.capitalCity = model.capitalCity;
        self.areaInSqKm = model.surface;
        self.north = model.north;
        self.south = model.south;
        self.east = model.east;
        self.west = model.west;
        self.countryCode = model.iso2Code;
    }
    
    return self;
}

@end



