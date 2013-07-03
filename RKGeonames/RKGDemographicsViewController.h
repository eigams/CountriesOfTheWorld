//
//  RKGDemographicsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKGDetailsViewController.h"

@interface RKGDemographicsViewController : RKGDetailsViewController

@property (nonatomic, strong) IBOutlet UILabel *totalPopulationLabel;
@property (nonatomic, strong) IBOutlet UILabel *populationGrowthLabel;
@property (nonatomic, strong) IBOutlet UILabel *birthRateLabel;
@property (nonatomic, strong) IBOutlet UILabel *deathRateLabel;

@end
