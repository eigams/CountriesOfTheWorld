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
                                            pathPattern:(NSString *)pathPattern
                                                andKeyPath:(NSString *)keyPath;

+ (void) fetchWorldBankIndicator:(NSString *)indicator
                     countryCode:(NSString *)countryCode
                            year:(NSString *)year
                            type:(int)type
                            text:(NSString *)text
                         success:(void (^)(NSString *Sink))handler
                         failure:(void (^)(void))failure;

+ (BOOL)savePictureToDisk:(NSString *)name data:(NSData *)pictureData;
+ (NSData *)loadPictureFromDisk:(NSString *)pictureName;

@end
