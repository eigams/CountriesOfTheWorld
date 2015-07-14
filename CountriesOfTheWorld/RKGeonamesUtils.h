//
//  RKGeonamesUtils.h
//  RKGeonames
//
//  Created by Stefan Burettea on 03/07/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RKGeonamesUtils : NSObject

+ (RKObjectRequestOperation *) setupObjectRequestOperation:(SEL)selctor
                                                   withURL:(NSString *)urlString
                                            pathPattern:(NSString *)pathPattern
                                                andKeyPath:(NSString *)keyPath;

+ (void) getDataWithOperation:(RKObjectRequestOperation *)operation completion:(void (^)(NSArray *, NSError *))completion;

+ (void) fetchWorldBankIndicator:(NSString *)indicator
                     countryCode:(NSString *)countryCode
                            year:(NSString *)year
                            type:(int)type
                            text:(NSString *)text
                         completion:(void (^)(NSString *sink, NSError *error))completion;

+ (BOOL)savePictureToDisk:(NSString *)name data:(NSData *)pictureData;
+ (NSData *)loadPictureFromDisk:(NSString *)pictureName;

@end
