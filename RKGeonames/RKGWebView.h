//
//  RKGWebView.h
//  RKGeonames
//
//  Created by Stefan Buretea on 11/7/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKGWebViewDelegate <NSObject>

@optional
- (void)didDoubleTapWebView;

@end

@interface RKGWebView : UIWebView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<RKGWebViewDelegate> rkgdelegate;

@end
