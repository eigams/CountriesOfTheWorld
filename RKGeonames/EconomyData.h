//
//  EconomyData.h
//  RKGeonames
//
//  Created by Stefan Burettea on 13/09/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EconomyData : NSObject

@property (nonatomic, copy, readonly) NSString *currency, *gdp, *gdppc, *gnipc;

- (id)initWithCurrency:(NSString *)currency
                   gdp:(NSString *)gdp
                 gdppc:(NSString *)gdppc
                 gnipc:(NSString *)gnipc;

+ (instancetype)data;

@end
