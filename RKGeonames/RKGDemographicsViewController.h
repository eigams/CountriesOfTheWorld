//
//  RKGDemographicsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKGDetailsViewController.h"

#import "DemographicDataClient.h"

@interface RKGDemographicsViewController : RKGDetailsViewController<DemographicDataClientDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;

@end
