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
#import "AdministrationData+TableRepresentation.h"
#import "Timezone.h"
#import "City.h"

#import "RKGeonamesConstants.h"

@interface RKGAdministrationViewController ()

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
    NSString *urlString = [NSString stringWithFormat:GET_CITY_URL, north, south, east, west];
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(cityMapping) withURL:urlString andPathPattern:nil andKeyPath:@"geonames"];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        NSArray *citiesArray = mappingResult.array;
        
        for(City *city in citiesArray)
        {
            if((YES == [city.name isEqualToString:self.country.capitalCity]) &&
               (YES == [city.countrycode isEqualToString:self.country.countryCode]))
            {
                [self getTimezoneData:[city.lat floatValue] and:[city.lng floatValue]];
                break;
            }
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        currentData = [[AdministrationData emptyAdministrationData] tr_tableRepresentation];
        
        [self.tableView reloadData];
    }];
    
    [operation start];
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
- (void) getTimezoneData:(float)latitude and:(float)longitude;
{
    NSString *urlString = [NSString stringWithFormat:GET_TIMEZONE_URL, latitude, longitude];
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(timezoneMapping) withURL:urlString andPathPattern:nil andKeyPath:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        if((nil == mappingResult) || (nil == mappingResult.array) || ([mappingResult.array count] < 1))
        {
            return ;
        }
        
        self.timezone = [mappingResult.array objectAtIndex:0];
        
        NSString *surface = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:[self.country.areaInSqKm floatValue]] numberStyle:NSNumberFormatterDecimalStyle];
        
        AdministrationData *adminData = [[AdministrationData alloc] initWithCapitalCity:self.country.capitalCity
                                                                                surface:[NSString stringWithFormat:@"%@ km%C", surface, square]
                                                                                currentTime:self.timezone.time
                                                                                timeZone:[NSString stringWithFormat:@"GMT%@", [self.timezone.gmtOffset intValue] < 0 ? self.timezone.gmtOffset : [NSString stringWithFormat:@"+%@", self.timezone.gmtOffset]]
                                                                                sunrise:self.timezone.sunrise
                                                                                sunset:self.timezone.sunset];
        currentData = [adminData tr_tableRepresentation];
        
        [self.tableView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        currentData = [[AdministrationData emptyAdministrationData] tr_tableRepresentation];
        
        [self.tableView reloadData];
    }];
    
    [operation start];
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

    [self addHomeButton];
    
    AdministrationData *adminData = [[AdministrationData alloc] initWithCapitalCity:LOADING_STRING
                                                                            surface:LOADING_STRING
                                                                        currentTime:LOADING_STRING
                                                                           timeZone:LOADING_STRING
                                                                            sunrise:LOADING_STRING
                                                                             sunset:LOADING_STRING];
    currentData = [adminData tr_tableRepresentation];
    
    [self.tableView reloadData];
    
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
