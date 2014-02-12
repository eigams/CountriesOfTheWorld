//
//  CountryModel.h
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CountryModel : NSManagedObject

@property (nonatomic, copy) NSString *capitalCity;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *east;
@property (nonatomic, retain) UIImage *flag;
@property (nonatomic, retain) NSData *flagData;
@property (nonatomic, copy) NSString *iso2Code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *north;
@property (nonatomic, copy) NSString *population;
@property (nonatomic, copy) NSString *south;
@property (nonatomic, copy) NSString *surface;
@property (nonatomic, copy) NSString *timezone;
@property (nonatomic, copy) NSString *west;

- (void)setFlagDataFromImage:(UIImage *)image;

@end
