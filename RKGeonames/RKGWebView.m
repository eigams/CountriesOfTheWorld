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
    
    UITapGestureRecognizer *singleFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerDoubleTap:)];
    singleFingerDoubleTap.numberOfTouchesRequired = 1;
    singleFingerDoubleTap.numberOfTapsRequired = 2;
    singleFingerDoubleTap.delegate = self;
    
    [self addGestureRecognizer:singleFingerDoubleTap];
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

-(void)handleSingleFingerDoubleTap:(id)sender {
    NSLog(@"Doulble click detected !");
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        //put you zooming action here
        NSLog(@"Doulble click detected !");
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
