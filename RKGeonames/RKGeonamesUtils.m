//
//  RKGeonamesUtils.m
//  RKGeonames
//
//  Created by Stefan Burettea on 03/07/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGeonamesUtils.h"
#import "MappingProvider.h"
#import "WorldBankIndicator.h"

@implementation RKGeonamesUtils

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: applicationDocumentsDirectory                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: setupObjectRequestOperation                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (BOOL)savePictureToDisk:(NSString *)name data:(NSData *)pictureData
{
    if((nil == name) || (nil == pictureData))
    {
        return NO;
    }
    
    NSString *path = [[RKGeonamesUtils applicationDocumentsDirectory] path];
    NSString *absolute = [[RKGeonamesUtils applicationDocumentsDirectory] absoluteString];
    
    NSString *pictureURL = [[[RKGeonamesUtils applicationDocumentsDirectory] path] stringByAppendingPathComponent:name];
    
    [pictureData writeToFile:pictureURL atomically:YES];
    
    return YES;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: setupObjectRequestOperation                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (NSData *)loadPictureFromDisk:(NSString *)pictureName
{
    NSString *picturePath = [[[RKGeonamesUtils applicationDocumentsDirectory] path] stringByAppendingPathComponent:pictureName];
    if(NO == [[NSFileManager defaultManager] fileExistsAtPath:picturePath])
    {
        NSLog(@"File not exists at path: %@", picturePath);
        
        return nil;
    }
    
    return [NSData dataWithContentsOfFile:picturePath];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: setupObjectRequestOperation                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:  success/failure                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
+ (RKObjectRequestOperation *) setupObjectRequestOperation:(SEL)selctor
                                                   withURL:(NSString *)urlString
                                            pathPattern:(NSString *)pathPattern
                                                andKeyPath:(NSString *)keyPath
{
    if(NO == [MappingProvider respondsToSelector:selctor])
    {
        NSLog(@"Selector %@ not implemented in class %@", NSStringFromSelector(selctor), [MappingProvider class]);
        
        return nil;
    }
    
    RKMapping *mapping = [MappingProvider performSelector:selctor];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                       pathPattern:pathPattern
                                                                                           keyPath:keyPath
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    return operation;
}

+ (void) getDataWithOperation:(RKObjectRequestOperation *)operation completion:(void (^)(NSArray *, NSError *))completion {
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        
        if((nil == mappingResult) || (nil == mappingResult.array) || ([mappingResult.array count] < 1)) {
            
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"No data received !", nil),
                                        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The server has reponded with empy data", nil),
                                        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Is the Internet connection running ?", nil) };
            
            completion(nil, [NSError errorWithDomain:@"RKGeonamesErrors" code:-101 userInfo:userInfo]);
            
            return ;
        }

        if(nil != completion) {
            completion(mappingResult.array, nil);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        if(nil != completion) {
            
            if(nil == error) {
                completion(nil, error);
            }
        }
        
    }];
    
    [operation start];
    
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: fetchWorldBankIndicator                             |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   sends a request for a specific indicator,           |+|
// |+|                   the worlbank.org can provide                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    NSString - indicator code                           |+|
// |+|                   NSString - country code                             |+|
// |+|                   int - type of data to be formatted (int/float)      |+|
// |+|                   NSString - additional text to add to the UILabel    |+|
// |+|                   Handler - will return the received text             |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
static NSString * const WORLD_BANK_INDICATOR_URL = @"http://api.worldbank.org/countries/%@/indicators/%@?format=json&date=%@:%@";
+ (void) fetchWorldBankIndicator:(NSString *)indicator
                     countryCode:(NSString *)countryCode
                            year:(NSString *)year
                            type:(int)type
                            text:(NSString *)text
                      completion:(void (^)(NSString *sink, NSError *error))completion {
    
    NSString *urlString = [NSString stringWithFormat:WORLD_BANK_INDICATOR_URL, countryCode, indicator, year, year];
    
    NSLog(@"urlString: %@", urlString);
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(worldBankIndicatorArrayMapping)
                                                                               withURL:urlString
                                                                           pathPattern:nil
                                                                            andKeyPath:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if((nil == mappingResult) || (nil == mappingResult.array) || ([mappingResult.array count] < 1))
        {
            NSLog(@"no results were fetched !");
            
            return ;
        }
        
        WorldBankIndicatorArray *wbiarray = [mappingResult.array firstObject];
        WorldBankIndicator *wbi = [wbiarray.indicators firstObject];
        
        if(nil != wbi.value) {
            NSLog(@"wbi :%@", wbi.value);
            
            NSString *additionalText = [NSString stringWithFormat:@"%@%@",
                                        [NSNumberFormatter localizedStringFromNumber:((type == 1) ? [NSNumber numberWithFloat:[wbi.value floatValue]] : [NSNumber numberWithInt:[wbi.value intValue]]) numberStyle:NSNumberFormatterDecimalStyle], text];
            
            completion(additionalText, nil);
        }
        else {
            completion(@"N/A", nil);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Cannot map an entity mapping that contains connection mappings with a data source whose managed object cache is nil." };
        
        completion(@"N/A", [NSError errorWithDomain:@"RKGeonamesError" code:-102 userInfo:userInfo]);
    }];
    
    [operation start];
}

@end
