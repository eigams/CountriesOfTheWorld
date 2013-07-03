//
//  MappingProvider.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappingProvider : NSObject

+ (RKMapping *) regionMapping;
+ (RKMapping *) adminRegionMapping;
+ (RKMapping *) incomeLevelMapping;
+ (RKMapping *) lendingTypeMapping;
+ (RKMapping *) pageInfoMapping;
+ (RKMapping *) geonamesCountryMapping;
+ (RKMapping *) countryMapping;
+ (RKMapping *) countryInfoMapping;
+ (RKMapping *) timezoneMapping;
+ (RKMapping *) cityMapping;
+ (RKMapping *) worldBankIndicatorArrayMapping;

@end
