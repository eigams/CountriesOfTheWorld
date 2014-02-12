//
//  CountryModel.m
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import "CountryModel.h"


@implementation CountryModel

@synthesize iso2Code;
@synthesize capitalCity;
@synthesize name;
@synthesize currency;
@synthesize surface;
@synthesize north;
@synthesize south;
@synthesize east;
@synthesize west;
@synthesize timezone;
@synthesize population;
@synthesize flag;
@synthesize flagData;

//- (id)init

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: awakeFromFetch                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *flagtn = [UIImage imageWithData:self.flagData];
    [self setPrimitiveValue:flagtn forKey:@"flag"];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: awakeFromInsert                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
//    [self setFlagDataFromImage:self.flag];
}


// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: setFlagDataFromImage                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)setFlagDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    CGRect newRect = CGRectMake(0, 0, 54, 40);
    
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setFlag:smallImage];
    
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setFlagData:data];
    
    UIGraphicsEndImageContext();
}

@end
