//
//  RKGDetailsViewController.h
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Country.h"

//@protocol DemographicDataClientDelegate;

@class RKGWebView;

@interface RKGDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    NSDictionary *currentData;
}

@property (nonatomic, strong) CountryGeonames *country;

@property (nonatomic, strong) IBOutlet RKGWebView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void) setDetails:(CountryGeonames *)Country;
- (void)addBarButtons:(SEL)refreshSelector;
- (void)setupTextFieldView;

- (void)setBackgroundImage:(UIImage *)image;
- (void)setupControlsWithZoom:(BOOL)zoomIn;

@end
