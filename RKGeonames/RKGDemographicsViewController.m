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
#import "DemographicData+TableRepresentation.h"

#import "ManagedObjectStore.h"
#import "CountryData.h"
#import "PopulationData.h"

#import "RKGeonamesConstants.h"

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
    
    DemographicDataClient *client = [DemographicDataClient sharedInstance];
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

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: updateView   withLocalStoredData                    |+|
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
- (BOOL)updateView:(DemographicDataClient *)client withLocalStoredData:(CountryData *)countryData
{
    void (^LoadDataBlock)() = ^{
        
        DemographicData *demoData = [[DemographicData alloc] initWithTotalPopulation:totalPopulation
                                                                    populationGrowth:populationGrowth
                                                                           birthRate:birthRate
                                                                           deathRate:deathRate];
        
        currentData = [demoData tr_tableRepresentation];
        
        [self.tableView reloadData];
        
    };
    
    NSSet *result = [countryData.populationData filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"year == %@", _selectedYear]];
    if ([result count] > 0)
    {
        _populationData = [[result allObjects] objectAtIndex:0];
        
        if(nil != _populationData)
        {
            if ((_populationData.total && ![_populationData.total isEqualToString:NOT_AVAILABLE_STRING]) &&
                (_populationData.growth && ![_populationData.growth isEqualToString:NOT_AVAILABLE_STRING]) &&
                (_populationData.birthRate && ![_populationData.birthRate isEqualToString:NOT_AVAILABLE_STRING]) &&
                (_populationData.deathRate && ![_populationData.deathRate isEqualToString:NOT_AVAILABLE_STRING]))
            {
                totalPopulation = _populationData.total ? _populationData.total : NOT_AVAILABLE_STRING;
                populationGrowth = _populationData.growth ? _populationData.growth : NOT_AVAILABLE_STRING;
                birthRate = _populationData.birthRate ? _populationData.birthRate : NOT_AVAILABLE_STRING;
                deathRate = _populationData.deathRate ? _populationData.deathRate : NOT_AVAILABLE_STRING;
                
                LoadDataBlock();
                
                totalPopulation  = LOADING_STRING;
                populationGrowth = LOADING_STRING;
                birthRate        = LOADING_STRING;
                deathRate        = LOADING_STRING;
                
                return YES;
            }
        }
    }
    
    totalPopulation  = LOADING_STRING;
    populationGrowth = LOADING_STRING;
    birthRate        = LOADING_STRING;
    deathRate        = LOADING_STRING;
    
    return NO;
}


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
- (BOOL)updateView:(DemographicDataClient *)client withRemoteData:(CountryData *)countryData
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
    
    if(nil == countryData)
    {
        countryData = (CountryData *)[[ManagedObjectStore sharedInstance] fetchItem:NSStringFromClass([CountryData class])
                                                                          predicate:[NSPredicate predicateWithFormat:@"name == %@", self.country.name]];
    }
    
    _populationData = (PopulationData *)[[ManagedObjectStore sharedInstance] managedObjectOfType:NSStringFromClass([PopulationData class])];
    _populationData.countryData = countryData;
    _populationData.year = _selectedYear;
    
    [bankIndicatorOutData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSArray *array = obj;
        
        [RKGeonamesUtils fetchWorldBankIndicator:key
                                  forCountryCode:self.country.countryCode
                                         forYear:_selectedYear
                                        withType:TYPE_FLOAT
                                         andText:[array objectAtIndex:2]
                                  withCompletion:^(NSString *Data){
                                      
                                      NSLog(@"Data: %@", Data);
                                      
                                      //KVC
                                      [self setValue:Data forKey:[array objectAtIndex:0]];
                                      [_populationData setValue:Data forKey:[array objectAtIndex:1]];
                                      
                                      [[ManagedObjectStore sharedInstance] updateItem:NSStringFromClass([CountryData class])
                                                                            predicate:[NSPredicate predicateWithFormat:@"name == %@", self.country.name]
                                                                       childPredicate:[NSPredicate predicateWithFormat:@"year == %@", _selectedYear]
                                                                                value:_populationData
                                                                                  key:@"populationData"];
                                      
                                      LoadDataBlock();
                                  }
                                         failure:^(){
                                             [self setValue:@"N/A" forKey:[array objectAtIndex:0]];
                                             
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
