//
//  RKGEconomicsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKGDetailsViewController.h"

@interface RKGEconomicsViewController : RKGDetailsViewController

@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (nonatomic, strong) IBOutlet UILabel *gdpLabel;
@property (nonatomic, strong) IBOutlet UILabel *gdppcLabel;
@property (nonatomic, strong) IBOutlet UILabel *gnipcLabel;

@end
