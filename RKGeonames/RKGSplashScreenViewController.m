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

- (void) dismiss:(BOOL)animated {
    [self dismissViewControllerAnimated:animated
                             completion:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(dismiss:)
               withObject:[NSNumber numberWithBool:YES]
               afterDelay:4.0];
}

@end
