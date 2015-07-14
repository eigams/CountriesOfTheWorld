//
//  UINavigationItem+RKGeonames.h
//  RKGeonames
//
//  Created by Stefan Buretea on 4/7/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem(RKGeonames)

@property (nonatomic, strong)IBOutletCollection(UIBarButtonItem) NSArray * rightBarButtonItemsCollection;
@property (nonatomic, strong)IBOutletCollection(UIBarButtonItem) NSArray * leftBarButtonItemsCollection;

@end
