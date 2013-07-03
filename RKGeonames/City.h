//
//  City.h
//  RKGeonames
//
//  Created by Stefan Burettea on 01/07/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, copy) NSString *fcodeName;
@property (nonatomic, copy) NSString *toponymName;
@property (nonatomic, copy) NSString *countrycode;
@property (nonatomic, copy) NSString *fcl;
@property (nonatomic, copy) NSString *fclName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *wikipedia;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *fcode;
@property (nonatomic, copy) NSString *geonameId;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *population;

@end
