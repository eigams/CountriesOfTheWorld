//
//  BouncePresentAnimationController.m
//  RKGeonames
//
//  Created by Stefan Buretea on 4/2/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import "BouncePresentAnimationController.h"

@implementation BouncePresentAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //Replace 'AppDelegate' with the name of your app delegate class to instantiate it
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *orgName = @"YOUR-ORG";
    NSString *appName = @"YOUR-APP";
    
    //Instantiate ApigeeClient to initialize the SDK
    self.apigeeClient = [[ApigeeClient alloc]
                                initWithOrganizationId:orgName
                                applicationId:appName];
    
    //Retrieve instances of ApigeeClient.monitoringClient and ApigeeClient.dataClient
    self.monitoringClient = [self.apigeeClient monitoringClient]; //used to call App Monitoring methods
    self.dataClient = [self.apigeeClient dataClient]; //used to call data methods
    
    
    // 1. obtain state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    // 2. obtain the container view
    UIView *containerView = [transitionContext containerView];
    
    // 3. set initial state 
}

@end
