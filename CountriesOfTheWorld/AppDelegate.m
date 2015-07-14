//
//  AppDelegate.m
//  CountriesOfTheWorld
//
//  Created by Stefan Buretea on 4/13/15.
//  Copyright (c) 2015 Stefan Buretea. All rights reserved.
//

#import "AppDelegate.h"
#import "RKGeonamesViewController.h"
#import "CountriesOfTheWorld-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    static UIViewController *splashVC;
    
    [RKGeonamesDataController loadRemoteData:^(NSArray *results,  NSError *error) {
        
        UINavigationController *nc = (UINavigationController *)self.window.rootViewController;
        
        NSString * storyboardName = @"MainStoryboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        
        RKGeonamesViewController *vc = (RKGeonamesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RKGeonamesViewController"];
        
        if(nil == error) {
            
            [vc setRemoteLoadedResults:results];
        }
        else {
            [vc setRemoteLoadedResults:@[]];
        }
        
        [nc setViewControllers:@[vc]];
        [nc setNavigationBarHidden:NO animated:YES];
    }];
    
    NSString * storyboardName = @"MainStoryboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    splashVC = [storyboard instantiateViewControllerWithIdentifier:@"WorldMapViewControllerID"];
    [(UINavigationController *)self.window.rootViewController setNavigationBarHidden:YES animated:NO];
    [(UINavigationController *)self.window.rootViewController pushViewController:splashVC animated:NO];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x388754)];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
