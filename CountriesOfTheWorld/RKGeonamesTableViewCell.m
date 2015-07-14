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
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    // ensure the gradient layers occupies the full bounds
//    _gradientLayer.frame = self.bounds;
}


@end
