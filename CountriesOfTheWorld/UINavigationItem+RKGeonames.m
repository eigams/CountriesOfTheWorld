//
//  UINavigationItem+RKGeonames.m
//  RKGeonames
//
//  Created by Stefan Buretea on 4/7/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

#import "UINavigationItem+RKGeonames.h"

@implementation UINavigationItem(RKGeonames)

- (void)setRightBarButtonItemsCollection:(NSArray *)rightBarButtonItemsCollection {
    self.rightBarButtonItems = [rightBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (void)setLeftBarButtonItemsCollection:(NSArray *)leftBarButtonItemsCollection {
    self.leftBarButtonItems = [leftBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (NSArray *)rightBarButtonItemsCollection {
    return self.rightBarButtonItems;
}

- (NSArray *)leftBarButtonItemsCollection {
    return self.leftBarButtonItems;
}

@end
