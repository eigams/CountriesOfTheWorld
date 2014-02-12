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
}

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) IBOutlet UITextField *year;

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
//        self.year.text = @"2011";
    }
    return self;
}

static int TYPE_FLOAT = 1;
static const UniChar perThousand = 0x2031;

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: loadData                                            |+|
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
- (BOOL)loadData
{
    DemographicData *demoData = [[DemographicData alloc] initWithTotalPopulation:totalPopulation
                                                                populationGrowth:populationGrowth
                                                                       birthRate:birthRate
                                                                       deathRate:deathRate];
    
    currentData = [demoData tr_tableRepresentation];
    
    [self.tableView reloadData];
    
    return YES;
}

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
static NSString *TOTAL_POPULATION_INDICATOR_STRING = @"SP.POP.TOTL";
static NSString *POPULATION_GROWTH_INDICATOR_STRING = @"SP.POP.GROW";
static NSString *BIRTH_RATE_INDICATOR_STRING = @"SP.DYN.CBRT.IN";
static NSString *DEATH_RATE_INDICATOR_STRING = @"SP.DYN.CDRT.IN";
- (void) getData
{
    //
    //try to load the data from local storage
    //
    
    CountryData *countryData = (CountryData *)[[ManagedObjectStore sharedInstance] fetchItem:NSStringFromClass([CountryData class])
                                                                                   predicate:[NSPredicate predicateWithFormat:@"name == %@", self.country.name]];
    
    if(nil != countryData)
    {
        NSSet *result = [countryData.populationData filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"year == %@", self.year.text]];
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
                    
                    [self loadData];
                    
                    return ;
                }
            }
        }
    }
    
    // when no data is stored locally, get it from the net
    
    currentData = [[DemographicData data] tr_tableRepresentation];
    
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
    _populationData.year = self.year.text;
    
    [bankIndicatorOutData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSArray *array = obj;
        
        [RKGeonamesUtils fetchWorldBankIndicator:key
                                  forCountryCode:self.country.countryCode
                                         forYear:self.year.text
                                        withType:TYPE_FLOAT
                                         andText:[array objectAtIndex:2]
                                  withCompletion:^(NSString *Data){
                                      
                                      NSLog(@"Data: %@", Data);
                                      
                                      //KVC
                                      [self setValue:Data forKey:[array objectAtIndex:0]];
                                      [_populationData setValue:Data forKey:[array objectAtIndex:1]];
                                      
                                      [[ManagedObjectStore sharedInstance] updateItem:NSStringFromClass([CountryData class])
                                                                            predicate:[NSPredicate predicateWithFormat:@"name == %@", self.country.name]
                                                                       childPredicate:[NSPredicate predicateWithFormat:@"year == %@", self.year.text]
                                                                                value:_populationData
                                                                                  key:@"populationData"];
                                      
                                      [self loadData];
                                  }
                                         failure:^(){
                                            [self setValue:@"N/A" forKey:[array objectAtIndex:0]];
                                            
                                            [self loadData];
                                         }];

    }];
}

- (void)setupTextFieldView
{
    self.year.delegate = self;
    if([YEAR_TEXT length] == 0)
    {
        YEAR_TEXT = @"2011";
    }

    [self.year setText:YEAR_TEXT];

    self.year.keyboardType = UIKeyboardTypeDecimalPad;
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
    
    [self getData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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


#pragma mark - UITextField delegate

static const unsigned int MIN_YEAR = 1980; //display data no early than 1980
static const unsigned int MAX_YEAR = 2013; //display data no early than 2013

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: textFieldShouldEndEditing                           |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   get the newly set year and refresh                  |+|
// |+|                   the collected data                                  |+|
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    unsigned int yearAsNumber = [textField.text intValue];
    if ((yearAsNumber < MIN_YEAR) || (yearAsNumber > MAX_YEAR))
    {
        self.year.text = @"2011";
    }
    else
    {
        self.year.text = textField.text;
    }
    
    NSLog(@"self.year.text: %@", self.year.text);
    
    YEAR_TEXT = self.year.text;
    
    [self getData];
    
    return YES;
}

@end
