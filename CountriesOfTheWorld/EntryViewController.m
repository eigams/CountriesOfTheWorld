//
//  ViewController.m
//  CountriesOfTheWorld
//
//  Created by Stefan Buretea on 4/13/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressBar.progressDirection = M13ProgressViewSegmentedBarProgressDirectionLeftToRight;
    self.progressBar.indeterminate = YES;
    self.progressBar.segmentShape = M13ProgressViewSegmentedBarSegmentShapeCircle;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
