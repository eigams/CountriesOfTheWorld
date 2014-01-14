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
                                            andPathPattern:(NSString *)pathPattern
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
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] responseDescriptors:@[responseDescriptor]];
    
    return operation;
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
                  forCountryCode:(NSString *)countryCode
                         forYear:(NSString *)year
                        withType:(int)type
                         andText:(NSString *)text
                     withCompletion:(void (^)(NSString *Sink))handler
                        failure:(void (^)(void))failure
{
    NSString *urlString = [NSString stringWithFormat:WORLD_BANK_INDICATOR_URL, countryCode, indicator, year, year];
    
    NSLog(@"urlString: %@", urlString);
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(worldBankIndicatorArrayMapping) withURL:urlString andPathPattern:nil andKeyPath:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if((nil == mappingResult) || (nil == mappingResult.array) || ([mappingResult.array count] < 1))
        {
            NSLog(@"no results were fetched !");
            
            return ;
        }
        
        WorldBankIndicatorArray *wbiarray = [mappingResult.array objectAtIndex:0];
        WorldBankIndicator *wbi = [wbiarray.indicators objectAtIndex:0];
        
        if(nil != wbi.value)
        {
            NSLog(@"wbi :%@", wbi.value);
            
            NSString *additionalText = [NSString stringWithFormat:@"%@%@",
                                        [NSNumberFormatter localizedStringFromNumber:((type == 1) ? [NSNumber numberWithFloat:[wbi.value floatValue]] : [NSNumber numberWithInt:[wbi.value intValue]]) numberStyle:NSNumberFormatterDecimalStyle], text];
            
            handler(additionalText);
        }
        else
        {
            handler(@"N/A");
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        failure();
    }];
    
    [operation start];
}

@end
