//
//  MappingProvider.m
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "MappingProvider.h"

#import "Country.h"
//#import "Timezone.h"
//#import "City.h"
//#import "WorldBankIndicator.h"

#import "CountriesOfTheWorld-Swift.h"

#pragma mark - Mapping Provider

@implementation MappingProvider

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: regionMapping                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) regionMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Region class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"value"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: adminRegionMapping                                  |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) adminRegionMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[AdminRegion class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"value"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: incomeLevelMapping                                  |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) incomeLevelMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[IncomeLevel class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"value"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: lendingTypeMapping                                  |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) lendingTypeMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LendingType class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"value"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: pageInfoMapping                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) pageInfoMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[PageInfo class]];
    
    [mapping addAttributeMappingsFromArray:@[@"page",@"pages",@"per_page",@"total"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: geonamesCountryMapping                              |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) geonamesCountryMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[CountryGeonames class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
     @"countryName":    @"name",
     @"currencyCode":   @"currency",
     @"fipsCode":       @"fipsCode",
     @"countryCode":    @"countryCode",
     @"isoNumeric":     @"isoNumeric",
     @"north":          @"north",
     @"capital":        @"capitalCity",
     @"continentName":  @"continentName",
     @"areaInSqKm":     @"areaInSqKm",
     @"languages":      @"languages",
     @"isoAlpha3":      @"isoAlpha3",
     @"continent":      @"continent",
     @"south":          @"south",
     @"east":           @"east",
     @"geonameId":      @"geonameId",
     @"west":           @"west",
     @"population":     @"population"
     }];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: countryMapping                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) countryMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKCountry class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
     @"id":          @"id",
     @"iso2Code":    @"iso2Code",
     @"name":        @"name",
     @"capitalCity": @"capitalCity",
     @"longitude":   @"longitude",
     @"latitude":    @"latitude"
     }];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"region" mapping:[MappingProvider regionMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"adminregion" mapping:[MappingProvider adminRegionMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"incomeLevel" mapping:[MappingProvider incomeLevelMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"lendingType" mapping:[MappingProvider lendingTypeMapping]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: countryInfoMapping                                  |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) countryInfoMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[CountryInfo class]];
    
    //    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"pageInfo" withMapping:[MappingProvider pageInfoMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"countries" withMapping:[MappingProvider countryMapping]]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: timezoneMapping                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) timezoneMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Timezone class]];
    
    [mapping addAttributeMappingsFromArray:@[@"time", @"countryName", @"sunset", @"rawOffset", @"dstOffset", @"countryCode", @"gmtOffset", @"lng", @"sunrise", @"timezoneId"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: cityMapping                                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) cityMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKGCity class]];
    
    [mapping addAttributeMappingsFromArray:@[@"fcodeName", @"toponymName", @"countrycode", @"fcl", @"fclName", @"name", @"wikipedia", @"lng", @"fcode", @"geonameId", @"lat", @"population"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: wbIndicatorMapping                                  |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) wbIndicatorMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKGIndicator class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"value"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: wbCountryMapping                                    |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) wbCountryMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKGWorldBankCountry class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"value"]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: worldBankIndicatorMapping                           |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) worldBankIndicatorMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKGWorldBankIndicator class]];
    
    [mapping addAttributeMappingsFromArray:@[@"value", @"decimal", @"date"]];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"indicator" mapping:[MappingProvider wbIndicatorMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"country" mapping:[MappingProvider wbCountryMapping]];
    
    return mapping;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: worldBankIndicatorArrayMapping                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKMapping *) worldBankIndicatorArrayMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKGWorldBankIndicatorArray class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"indicators" withMapping:[MappingProvider worldBankIndicatorMapping]]];
    
    return mapping;
}


@end

