//
//  RKGeonamesTableViewCell.m
//  RKGeonames
//
//  Created by Stefan Burettea on 22/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGeonamesTableViewCell.h"

@implementation RKGeonamesTableViewCell
{
    CAGradientLayer* _gradientLayer;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _flagImage = [[UIImageView alloc] initWithFrame:(CGRectMake(9, 20, 68, 50))];
        _flagImage.contentMode = UIViewContentModeScaleAspectFit;
        
        _countryNameLabel = [[UILabel alloc] initWithFrame:(CGRectMake(88, 10, 173, 42))];
        _countryNameLabel.font = [UIFont boldSystemFontOfSize:21];
        _countryNameLabel.textAlignment = NSTextAlignmentLeft;
        
        _capitalCityLabel = [[UILabel alloc] initWithFrame:(CGRectMake(88, 49, 113, 21))];
        _capitalCityLabel.font = [UIFont systemFontOfSize:13];
        _capitalCityLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_flagImage];
        [self.contentView addSubview:_countryNameLabel];
        [self.contentView addSubview:_capitalCityLabel];
        
        // add a layer that overlays the cell adding a subtle gradient effect
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    // ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;
}


@end
