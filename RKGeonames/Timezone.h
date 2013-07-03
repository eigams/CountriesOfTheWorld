//
//  Timezone.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timezone : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *sunset;
@property (nonatomic, copy) NSString *rawOffset;
@property (nonatomic, copy) NSString *dstOffset;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *gmtOffset;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *sunrise;
@property (nonatomic, copy) NSString *timezoneId;

@end
