//
//  RKGAdministrationViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGAdministrationViewController.h"

#import "Timezone.h"
#import "City.h"
#import "MappingProvider.h"
#import "RKGeonamesUtils.h"

@interface RKGAdministrationViewController ()

@property (nonatomic, strong) Timezone *timezone;

@end

@implementation RKGAdministrationViewController

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
- (void) getCities:(NSString *)north south:(NSString *)south west:(NSString *)west east:(NSString *)east
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/citiesJSON?north=%@&south=%@&east=%@&west=%@&username=sbpuser", north, south, east, west];
    
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
// |+|    PARAMETERS:    none                                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void) getTimezoneData:(float)latitude and:(float)longitude;
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/timezoneJSON?lat=%.2f&lng=%.2f&username=sbpuser", latitude, longitude];
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(timezoneMapping) withURL:urlString andPathPattern:nil andKeyPath:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        self.timezone = [mappingResult.array objectAtIndex:0];
        
        self.timeZoneLabel.text = [NSString stringWithFormat:@"GMT%@", [self.timezone.gmtOffset intValue] < 0 ? self.timezone.gmtOffset : [NSString stringWithFormat:@"+%@", self.timezone.gmtOffset]];
        self.currentTimeLabel.text = self.timezone.time;
        self.sunriseLabel.text = self.timezone.sunrise;
        self.sunsetLabel.text = self.timezone.sunset;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
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
    
    [self getCities:self.country.north south:self.country.south west:self.country.west east:self.country.east];

    self.capitalCityLabel.text = self.country.capitalCity;
    self.areaLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:[self.country.areaInSqKm floatValue]] numberStyle:NSNumberFormatterDecimalStyle];
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
