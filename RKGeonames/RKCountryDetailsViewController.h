//
//  RKCountryDetailsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 28/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+RKGeonames.h"
#import "UINavigationItem+iOSSpacing.h"

@class CountryGeonames;

@interface RKCountryDetailsViewController : UIViewController

@property (nonatomic, strong) CountryGeonames *country;

@end
