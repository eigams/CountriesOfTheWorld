//
//  WorldBankIndicator.m
//  RKGeonames
//
//  Created by Stefan Burettea on 01/07/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "WorldBankIndicator.h"


@implementation Indicator

@synthesize id;
@synthesize value;

@end

@implementation WBCountry

@synthesize id;
@synthesize value;

@end

@implementation WorldBankIndicator

@synthesize indicator;
@synthesize country;
@synthesize value;
@synthesize decimal;
@synthesize date;

@end

@implementation WorldBankIndicatorArray

@synthesize indicators;

@end