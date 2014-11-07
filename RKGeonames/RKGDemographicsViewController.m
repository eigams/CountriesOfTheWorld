//
//  RKGDemographicsViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGDemographicsViewController.h"

#import "MappingProvider.h"
#import "WorldBankIndicator.h"
#import "RKGeonamesUtils.h"

#import "ManagedObjectStore.h"
#import "CountryData.h"

#import "RKGeonamesConstants.h"
#import "RKGeonames-Swift.h"

static NSString * YEAR_TEXT = @"";

@interface RKGDemographicsViewController ()
{
    NSString *totalPopulation;
    NSString *populationGrowth;
    NSString *deathRate;
    NSString *birthRate;
    
    __block PopulationData *_populationData;
    
    NSArray *_pickerData;
    NSString *_selectedYear;
}

@property (nonatomic, strong) NSArray *items;

@end

@implementation RKGDemographicsViewController

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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

    }
    return self;
}

static int TYPE_FLOAT = 1;
static const UniChar perThousand = 0x2031;

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: getData                                             |+|
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
- (void) getData
{
    //
    //try to load the data from local storage
    //
    
    RKGDemographicDataClient *client = [RKGDemographicDataClient sharedInstance];
    client.delegate = self;
    
    [client getDataForCountry:self.country.name];
}

static const int START_YEAR = 1970;

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: setupPicker                                         |+|
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
- (void)setupPicker
{
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    
    _selectedYear = @"2011";
    
    static NSDateFormatter *formatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
    });
    
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * number = [f numberFromString:yearString];
    
    NSMutableArray *sink = [NSMutableArray array];
    for(int i = [number intValue] - 1; i >= START_YEAR; --i)
    {
        [sink addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _pickerData = [sink copy];
    
    [self.yearPicker reloadAllComponents];
    [self.yearPicker selectRow:2 inComponent:0 animated:YES];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: viewDidLoad                                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   Do any additional setup after loading the view      |+|
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
static const UniChar per_mille = 0x2030;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addBarButtons:@selector(getData)];
    
    totalPopulation  = LOADING_STRING;
    populationGrowth = LOADING_STRING;
    birthRate        = LOADING_STRING;
    deathRate        = LOADING_STRING;
    
    [self setupPicker];
    
    [self getData];
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


#pragma mark - UIPickerView delegate

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [_pickerData count];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [_pickerData objectAtIndex:row];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    _selectedYear = [_pickerData objectAtIndex:row];
    
    [self.tableView reloadData];
    
    [self getData];
}

#pragma mark - DemographicDataDelegates

static NSString *const TOTAL_POPULATION_INDICATOR_STRING = @"SP.POP.TOTL";
static NSString *const POPULATION_GROWTH_INDICATOR_STRING = @"SP.POP.GROW";
static NSString *const BIRTH_RATE_INDICATOR_STRING = @"SP.DYN.CBRT.IN";
static NSString *const DEATH_RATE_INDICATOR_STRING = @"SP.DYN.CDRT.IN";
// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: updateView   withRemoteData                         |+|
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
- (BOOL)updateView:(RKGDemographicDataClient *)client
{
    void (^LoadDataBlock)() = ^{
        
        DemographicData *demoData = [[DemographicData alloc] initWithTotalPopulation:totalPopulation
                                                                    populationGrowth:populationGrowth
                                                                           birthRate:birthRate
                                                                           deathRate:deathRate];
        
        currentData = [demoData tr_tableRepresentation];
        
        [self.tableView reloadData];        
    };

    LoadDataBlock();
    
    NSDictionary *bankIndicatorOutData = @{TOTAL_POPULATION_INDICATOR_STRING: @[@"totalPopulation", @"total", @""],
                                           POPULATION_GROWTH_INDICATOR_STRING: @[@"populationGrowth", @"growth", @"%"],
                                           BIRTH_RATE_INDICATOR_STRING: @[@"birthRate", @"birthRate", [NSString stringWithFormat:@"%C", per_mille]],
                                           DEATH_RATE_INDICATOR_STRING: @[@"deathRate", @"deathRate", [NSString stringWithFormat:@"%C", per_mille]]};
    
    [bankIndicatorOutData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSArray *array = obj;
        
        [RKGeonamesUtils fetchWorldBankIndicator:key
                                     countryCode:self.country.countryCode
                                            year:_selectedYear
                                            type:TYPE_FLOAT
                                            text:[array objectAtIndex:2]
                                         success:^(NSString *Data){
                                      
                                      NSLog(@"Data: %@", Data);
                                      
                                      //KVC
                                      [self setValue:Data forKey:[array firstObject]];
                                      
                                      LoadDataBlock();
                                  }
                                         failure:^(){
                                             [self setValue:@"N/A" forKey:[array firstObject]];
                                             
                                             LoadDataBlock();
                                         }];
        
    }];
    
    totalPopulation  = LOADING_STRING;
    populationGrowth = LOADING_STRING;
    birthRate        = LOADING_STRING;
    deathRate        = LOADING_STRING;
    
    return YES;
}


@end
