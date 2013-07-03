//
//  RKGDetailsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface RKGDetailsViewController : UIViewController

@property (nonatomic, strong) CountryGeonames *country;

@property (nonatomic, strong) IBOutlet UIWebView *mapView;

- (void) setDetails:(CountryGeonames *)Country;

@end
