//
//  RKGeonamesUtils.h
//  RKGeonames
//
//  Created by Stefan Burettea on 03/07/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKGeonamesUtils : NSObject

+ (RKObjectRequestOperation *) setupObjectRequestOperation:(SEL)selctor
                                                   withURL:(NSString *)urlString
                                            andPathPattern:(NSString *)pathPattern
                                                andKeyPath:(NSString *)keyPath;

+ (void) fetchWorldBankIndicator:(NSString *)indicator
                  forCountryCode:(NSString *)countryCode
                        withType:(int)type
                         andText:(NSString *)text
           withActivityIndicator:(UIActivityIndicatorView *)activityIndicator
                     withHandler:(void (^)(NSString *Sink))handler;

@end
