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
        self.year.text = @"2011";
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
    currentData = [[DemographicData data] tr_tableRepresentation];
    
    NSDictionary *bankIndicatorOutData = @{TOTAL_POPULATION_INDICATOR_STRING: @[@"totalPopulation", @""],
                                           POPULATION_GROWTH_INDICATOR_STRING: @[@"populationGrowth", @"%"],
                                           BIRTH_RATE_INDICATOR_STRING: @[@"birthRate", [NSString stringWithFormat:@"%C", per_mille]],
                                           DEATH_RATE_INDICATOR_STRING: @[@"deathRate", [NSString stringWithFormat:@"%C", per_mille]]};
    
    [bankIndicatorOutData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSArray *array = obj;
        
        [RKGeonamesUtils fetchWorldBankIndicator:key
                                  forCountryCode:self.country.countryCode
                                         forYear:self.year.text
                                        withType:TYPE_FLOAT
                                         andText:[array objectAtIndex:1]
                                  withCompletion:^(NSString *Data){
                                      
                                      NSLog(@"Data: %@", Data);
                                      
                                      //KVC
                                      [self setValue:Data forKey:[array objectAtIndex:0]];
                                      
                                      [self loadData];
                                  }
                                         failure:^(){
                                            [self setValue:@"N/A" forKey:[array objectAtIndex:0]];
                                            
                                            [self loadData];
                                         }];

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
    
    self.year.delegate = self;
    [self.year setText:@"2011"];
    self.year.keyboardType = UIKeyboardTypeDecimalPad;
    
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
    self.year.text = textField.text;
    
    [self getData];
    
    return YES;
}


@end
