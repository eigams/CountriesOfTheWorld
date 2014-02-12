//
//  RKGeonamesTableViewCell.m
//  RKGeonames
//
//  Created by Stefan Burettea on 22/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGeonamesTableViewCell.h"

@implementation RKGeonamesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _flagImage = [[UIImageView alloc] initWithFrame:(CGRectMake(9, 20, 68, 50))];
//        _flagImage.contentMode = UIViewContentModeScaleAspectFit;
        
        _countryNameLabel = [[UILabel alloc] initWithFrame:(CGRectMake(88, 10, 173, 42))];
        _countryNameLabel.font = [UIFont boldSystemFontOfSize:21];
        _countryNameLabel.textAlignment = NSTextAlignmentLeft;
        
        _capitalCityLabel = [[UILabel alloc] initWithFrame:(CGRectMake(88, 49, 113, 21))];
        _capitalCityLabel.font = [UIFont systemFontOfSize:13];
        _capitalCityLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_flagImage];
        [self.contentView addSubview:_countryNameLabel];
        [self.contentView addSubview:_capitalCityLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
