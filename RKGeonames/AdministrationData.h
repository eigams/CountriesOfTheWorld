//
//  AdministrationData.h
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdministrationData : NSObject

@property (nonatomic, copy, readonly) NSString *capitalCity, *surface, *currentTime, *timeZone, *sunrise, *sunset;

- (id)initWithCapitalCity:(NSString *)capitalCity
                  surface:(NSString *)surface
              currentTime:(NSString *)currentTime
                 timeZone:(NSString *)timeZone
                  sunrise:(NSString *)sunrise
                   sunset:(NSString *)sunset;

+ (instancetype)data;

@end
