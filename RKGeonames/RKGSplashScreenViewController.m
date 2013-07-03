//
//  RKGSplashScreenViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 27/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGSplashScreenViewController.h"

@interface RKGSplashScreenViewController ()

@end

@implementation RKGSplashScreenViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:3.0];
}

@end
