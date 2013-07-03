//
//  Country.h
//  RKGeonames
//
//  Created by Stefan Burettea on 22/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *value;

@end

@interface AdminRegion : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *value;

@end

@interface IncomeLevel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *value;

@end

@interface LendingType : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *value;

@end

@interface PageInfo : NSObject

@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *total;

@end

@interface CountryGeonames : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *fipsCode;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *isoNumeric;
@property (nonatomic, copy) NSString *north;
@property (nonatomic, copy) NSString *capitalCity;
@property (nonatomic, copy) NSString *continentName;
@property (nonatomic, copy) NSString *areaInSqKm;
@property (nonatomic, copy) NSString *languages;
@property (nonatomic, copy) NSString *isoAlpha3;
@property (nonatomic, copy) NSString *continent;
@property (nonatomic, copy) NSString *south;
@property (nonatomic, copy) NSString *east;
@property (nonatomic, copy) NSString *geonameId;
@property (nonatomic, copy) NSString *west;
@property (nonatomic, copy) NSString *population;

@end

@interface Country : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *iso2Code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Region *region;
@property (nonatomic, strong) AdminRegion *adminregion;
@property (nonatomic, strong) IncomeLevel *incomeLevel;
@property (nonatomic, strong) LendingType *lendingType;
@property (nonatomic, copy) NSString *capitalCity;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@end

@interface CountryInfo : NSObject

@property (nonatomic, strong) NSArray *countries;

@end


