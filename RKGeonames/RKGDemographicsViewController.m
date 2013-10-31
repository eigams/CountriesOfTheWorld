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

#import "RKGeonamesConstants.h"

@interface RKGDemographicsViewController ()
{
    NSString *totalPopulation;
    NSString *populationGrowth;
    NSString *deathRate;
    NSString *birthRate;
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
        // Custom initialization
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
    currentData = [[DemographicData emptyDemographicData] tr_tableRepresentation];    
    
    [RKGeonamesUtils fetchWorldBankIndicator:TOTAL_POPULATION_INDICATOR_STRING
                              forCountryCode:self.country.countryCode
                                    withType:TYPE_FLOAT
                                     andText:@""
                                 withCompletion:^(NSString *Data){
                                         totalPopulation = Data;
                                         
                                         [self loadData];
                                     }
                                     failure:^(){
                                         
                                         [self.tableView reloadData];
                                     }];
    
    [RKGeonamesUtils fetchWorldBankIndicator:POPULATION_GROWTH_INDICATOR_STRING
                              forCountryCode:self.country.countryCode
                                    withType:TYPE_FLOAT andText:@"%"
                                 withCompletion:^(NSString *Data) {
                                         populationGrowth = Data;
                                         
                                         [self loadData];
                                     }
                                     failure:^(){
                                         
                                         [self.tableView reloadData];
                                     }];
    
    [RKGeonamesUtils fetchWorldBankIndicator:BIRTH_RATE_INDICATOR_STRING
                              forCountryCode:self.country.countryCode
                                    withType:TYPE_FLOAT andText:[NSString stringWithFormat:@"%C", per_mille]
                                 withCompletion:^(NSString *Data) {
                                         birthRate = Data;
                                         
                                         [self loadData];
                                    }
                                    failure:^{
                                        
                                        [self.tableView reloadData];
                                    }];
    
    [RKGeonamesUtils fetchWorldBankIndicator:DEATH_RATE_INDICATOR_STRING
                              forCountryCode:self.country.countryCode
                                    withType:TYPE_FLOAT
                                     andText:[NSString stringWithFormat:@"%C", per_mille]
                                 withCompletion:^(NSString *Data) {
                                        deathRate = Data;

                                        [self loadData];
                                    }
                                    failure:^{
                                        
//                                        currentData = [[DemographicData emptyDemographicData] tr_tableRepresentation];
                                        
                                        [self.tableView reloadData];
                                    }];
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
    
    [self addHomeButton];
    
    totalPopulation  = LOADING_STRING;
    populationGrowth = LOADING_STRING;
    birthRate        = LOADING_STRING;
    deathRate        = LOADING_STRING;
    
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

@end
