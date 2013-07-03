//
//  WorldBankIndicator.h
//  RKGeonames
//
//  Created by Stefan Burettea on 01/07/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Indicator : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *value;

@end

@interface WBCountry : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *value;

@end


@interface WorldBankIndicator : NSObject

@property (nonatomic, strong) Indicator *indicator;
@property (nonatomic, strong) WBCountry *country;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *decimal;
@property (nonatomic, copy) NSString *date;

@end

@interface WorldBankIndicatorArray : NSObject

@property (nonatomic, strong) NSArray *indicators;

@end
