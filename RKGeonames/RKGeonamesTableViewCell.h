//
//  RKGeonamesTableViewCell.h
//  RKGeonames
//
//  Created by Stefan Burettea on 22/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKGeonamesTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *countryNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *capitalCityLabel;
@property (nonatomic, strong) IBOutlet UIImageView *flagImage;

@end
