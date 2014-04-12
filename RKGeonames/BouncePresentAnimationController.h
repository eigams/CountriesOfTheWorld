//
//  BouncePresentAnimationController.h
//  RKGeonames
//
//  Created by Stefan Buretea on 4/2/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ApigeeiOSSDK/Apigee.h>

@interface BouncePresentAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) ApigeeClient *apigeeClient; //object for initializing the SDK
@property (strong, nonatomic) ApigeeMonitoringClient *monitoringClient; //client object for Apigee App Monitoring methods
@property (strong, nonatomic) ApigeeDataClient *dataClient;	//client object for data methods

@end
