//
//  RKGAdministrationViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGAdministrationViewController.h"

#import "MappingProvider.h"
#import "RKGeonamesUtils.h"
#import "CountryData.h"
//#import "Timezone.h"
//#import "City.h"

#import "ManagedObjectStore.h"
#import "RKGeonames-Swift.h"

#import "RKGeonamesConstants.h"
#import "RKGeonames-Swift.h"

@interface RKGAdministrationViewController ()
{
    NSString *_timezoneString;
}

@property (nonatomic, strong) Timezone *timezone;

@end

@implementation RKGAdministrationViewController

@synthesize tableView;
@synthesize timezone;

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: initWithNibName                                     |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   default implementation                              |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: getCities                                           |+|
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
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
static NSString *GET_CITY_URL = @"http://api.geonames.org/citiesJSON?north=%@&south=%@&east=%@&west=%@&username=sbpuser";
- (void) getCities:(NSString *)north south:(NSString *)south west:(NSString *)west east:(NSString *)east
{
    @try
    {
        NSString *urlString = [NSString stringWithFormat:GET_CITY_URL, north, south, east, west];
        
        RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(cityMapping)
                                                                                   withURL:urlString
                                                                               pathPattern:nil
                                                                                andKeyPath:@"geonames"];

        static NSPredicate *predicate;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            predicate = [NSPredicate predicateWithFormat:@"(%@ contains name) AND (countrycode == %@)", self.country.capitalCity, self.country.countryCode];
        });
        
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
            NSArray *citiesArray = mappingResult.array;
            
            NSArray *filteredItems = [citiesArray filteredArrayUsingPredicate:predicate];
            if ((nil != filteredItems) && [filteredItems count]) {
                
                RKGCity *city = [filteredItems firstObject];
                if(nil != city) {
                    [self getTimezoneData:@[[NSNumber numberWithFloat:[city.lat floatValue]], [NSNumber numberWithFloat:[city.lng floatValue]]]];
                }
            }
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"ERROR: %@", error);
            NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
            
            currentData = [[AdministrationData data] tr_tableRepresentation];
            
            [self.tableView reloadData];
        }];
        
        [operation start];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Execption caught: %@", [exception reason]);
        
        currentData = [[AdministrationData data] tr_tableRepresentation];
        
        [self.tableView reloadData];
    }
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: getTimezoneData                                     |+|
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
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
static const UniChar square = 0x00B2;
static NSString *GET_TIMEZONE_URL = @"http://api.geonames.org/timezoneJSON?lat=%.2f&lng=%.2f&username=sbpuser";
- (void) getTimezoneData:(NSArray *)latitudeAndLongitude;
{
    NSString *urlString = [NSString stringWithFormat:GET_TIMEZONE_URL, [[latitudeAndLongitude objectAtIndex:0] floatValue], [[latitudeAndLongitude objectAtIndex:1] floatValue]];
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(timezoneMapping) withURL:urlString pathPattern:nil andKeyPath:nil];
    
    NSString *surface = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:[self.country.areaInSqKm floatValue]] numberStyle:NSNumberFormatterDecimalStyle];
    static NSString *timeZone = nil;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        if((nil == mappingResult) || (nil == mappingResult.array) || ([mappingResult.array count] < 1))
        {
            return ;
        }
        
        self.timezone = [mappingResult.array objectAtIndex:0];

        if(YES == [_timezoneString isEqualToString:LOADING_STRING])
        {
            timeZone = [NSString stringWithFormat:@"GMT%@", [self.timezone.gmtOffset intValue] < 0 ? self.timezone.gmtOffset : [NSString stringWithFormat:@"+%@", self.timezone.gmtOffset]];
            
            [[ManagedObjectStore sharedInstance] updateItem:NSStringFromClass([CountryData class])
                                                  predicate:[NSPredicate predicateWithFormat:@"name = %@", self.country.name]
                                                      value:timeZone
                                                        key:@"timezone"];
        }
        else
        {
            timeZone = _timezoneString;
        }
        
        AdministrationData *adminData = [[AdministrationData alloc] initWithCapitalCity:self.country.capitalCity
                                                                                surface:[NSString stringWithFormat:@"%@ km%C", surface, square]
                                                                                currentTime:self.timezone.time
                                                                                timeZone:timeZone
                                                                                sunrise:self.timezone.sunrise
                                                                                sunset:self.timezone.sunset];
        currentData = [adminData tr_tableRepresentation];
        
        [self.tableView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        AdministrationData *adminData = [[AdministrationData alloc] initWithCapitalCity:self.country.capitalCity ? self.country.capitalCity : NOT_AVAILABLE_STRING
                                                                                surface:surface ? [NSString stringWithFormat:@"%@ km%C", surface, square] : NOT_AVAILABLE_STRING
                                                                            currentTime:NOT_AVAILABLE_STRING
                                                                               timeZone:timeZone ? timeZone : NOT_AVAILABLE_STRING
                                                                                sunrise:NOT_AVAILABLE_STRING
                                                                                 sunset:NOT_AVAILABLE_STRING];
        
        currentData = [adminData tr_tableRepresentation];
        
        [self.tableView reloadData];
    }];
    
    [operation start];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: getCities                                           |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)getCities
{
    [self setDefaults];
    
    [self getCities:self.country.north
              south:self.country.south
               west:self.country.west
               east:self.country.east];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: setDefaults                                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)setDefaults
{
    NSString *surface = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:[self.country.areaInSqKm floatValue]] numberStyle:NSNumberFormatterDecimalStyle];
    
    CountryData *countryData = (CountryData *)[[ManagedObjectStore sharedInstance] fetchItem:NSStringFromClass([CountryData class])
                                                                                   predicate:[NSPredicate predicateWithFormat:@"name = %@", self.country.name]];
    
    _timezoneString = ((countryData.timezone != nil && [countryData.timezone length] > 0)) ? countryData.timezone : LOADING_STRING;
    
    AdministrationData *adminData = [[AdministrationData alloc] initWithCapitalCity:self.country.capitalCity
                                                                            surface:[NSString stringWithFormat:@"%@ km%C", surface, square]
                                                                        currentTime:LOADING_STRING
                                                                           timeZone:_timezoneString
                                                                            sunrise:LOADING_STRING
                                                                             sunset:LOADING_STRING];
    currentData = [adminData tr_tableRepresentation];
    
    [self.tableView reloadData];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: viewDidLoad                                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   stop collecting data                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self addBarButtons:@selector(getCities)];
    
    [self setDefaults];
    
    [self getCities:self.country.north
              south:self.country.south
               west:self.country.west
               east:self.country.east];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   default implementation                              |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
