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

@interface RKGDemographicsViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation RKGDemographicsViewController

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   default implementation                                |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    PARAMETERS:                                                    |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    RETURN VALUE:                                       |+|
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
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                   |+|
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
- (void) getWBIndicator:(NSString *)indicator forCountryCode:(NSString *)countryCode toLabel:(UILabel *)label withType:(int)type andText:(NSString *)text
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.worldbank.org/countries/%@/indicators/%@?format=json&date=2011:2011", countryCode, indicator];
    
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(worldBankIndicatorArrayMapping) withURL:urlString andPathPattern:nil andKeyPath:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.items = mappingResult.array;
        
        WorldBankIndicatorArray *wbiArray = [self.items objectAtIndex:0];
        WorldBankIndicator *wbi = [wbiArray.indicators objectAtIndex:0];
        
        if(nil != wbi.value)
        {
            NSString *additionalText = [NSString stringWithFormat:@"%@%@",
                                        [NSNumberFormatter localizedStringFromNumber:((type == 1) ? [NSNumber numberWithFloat:[wbi.value floatValue]] : [NSNumber numberWithInt:[wbi.value intValue]]) numberStyle:NSNumberFormatterDecimalStyle], text];
            
            label.text = additionalText;
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
    }];
    
    [operation start];
}

static int TYPE_FLOAT = 1;

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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RKGeonamesUtils fetchWorldBankIndicator:@"SP.POP.TOTL" forCountryCode:self.country.countryCode toLabel:self.totalPopulationLabel withType:TYPE_FLOAT andText:@""];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RKGeonamesUtils fetchWorldBankIndicator:@"SP.POP.GROW" forCountryCode:self.country.countryCode toLabel:self.populationGrowthLabel withType:TYPE_FLOAT andText:@"%"];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RKGeonamesUtils fetchWorldBankIndicator:@"SP.DYN.CBRT.IN" forCountryCode:self.country.countryCode toLabel:self.birthRateLabel withType:TYPE_FLOAT andText:@"/1000"];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RKGeonamesUtils fetchWorldBankIndicator:@"SP.DYN.CDRT.IN" forCountryCode:self.country.countryCode toLabel:self.deathRateLabel withType:TYPE_FLOAT andText:@"/1000"];
    });

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
