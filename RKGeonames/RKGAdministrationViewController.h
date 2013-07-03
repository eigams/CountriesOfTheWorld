//
//  RKGAdministrationViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKGDetailsViewController.h"

@interface RKGAdministrationViewController : RKGDetailsViewController

@property (nonatomic, strong) IBOutlet UILabel *capitalCityLabel;
@property (nonatomic, strong) IBOutlet UILabel *areaLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeZoneLabel;
@property (nonatomic, strong) IBOutlet UILabel *sunriseLabel;
@property (nonatomic, strong) IBOutlet UILabel *sunsetLabel;

@end
