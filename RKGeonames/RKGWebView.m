//
//  RKGWebView.m
//  RKGeonames
//
//  Created by Stefan Buretea on 11/7/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import "RKGWebView.h"

@implementation RKGWebView

- (void) initGestureRecognizer {
    
    return;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchGesture];
//    self.scalesPageToFit = YES;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
        // Initialization code.
        [self initGestureRecognizer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self initGestureRecognizer];
    }
    return self;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    if([recognizer scale] < 1) {
        NSLog(@"pinch in");
    }
    else {
        NSLog(@"pinch out");
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
