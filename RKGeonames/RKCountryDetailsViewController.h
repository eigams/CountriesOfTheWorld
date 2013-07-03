//
//  RKCountryDetailsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 28/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKGDetailsViewController.h"

@interface RKCountryDetailsViewController : RKGDetailsViewController

@property (nonatomic, strong) IBOutlet UIButton *buttonAdministration;
@property (nonatomic, strong) IBOutlet UIButton *buttonDemographics;
@property (nonatomic, strong) IBOutlet UIButton *buttonEconomics;

@end
