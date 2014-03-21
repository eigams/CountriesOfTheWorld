//
//  RKGeonamesViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 21/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGeonamesViewController.h"

#import "MappingProvider.h"
#import "Country.h"

#import "RKGeonamesTableViewCell.h"
#import "RKGSplashScreenViewController.h"
#import "RKCountryDetailsViewController.h"
#import "RKGeonamesUtils.h"

#import "ManagedObjectStore.h"
#import "CountryData.h"

#import "MSCellAccessory.h"

@interface NSArray(CompareHelper)

- (NSArray *)compare:(NSArray *)array;

@end

@implementation NSArray(CompareHelper)

-(NSArray *)compare:(NSArray *)source;
{
    //save a copy to process later
    NSMutableArray *snapshot = [NSMutableArray arrayWithArray:self];
    
    NSMutableSet *setSelf = [NSMutableSet set];
    NSMutableSet *setSource = [NSMutableSet set];
    
    [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        CountryGeonames *cg = (CountryGeonames *)obj;
        [setSource addObject:cg.name];
    }];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CountryGeonames *cg = (CountryGeonames *)obj;
        [setSelf addObject:cg.name];
    }];
    
    NSSet *setSnapshot = [NSSet setWithSet:setSelf];
    
    //compare sets to determine any possible differences
    [setSelf minusSet:setSource];
    if([setSelf count] == 0)
    {
        return self;
    }
    
    if ([setSelf count] > 0)
    {
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CountryGeonames *cg = (CountryGeonames *)obj;
            if ([setSelf containsObject:cg.name])
            {
                [snapshot removeObject:cg];
            }
        }];
        
        return [NSArray arrayWithArray:snapshot];
    }
    
    [setSource minusSet:setSnapshot];
    if ([setSource count] > 0)
    {
        [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CountryGeonames *cg = (CountryGeonames *)obj;
            if ([setSource containsObject:cg.name])
            {
                [snapshot addObject:cg];
            }
        }];
        
        return [NSArray arrayWithArray:snapshot];
    }
    
    return nil;
}

@end

@interface RKGeonamesViewController ()
{
    NSUInteger  totalCountries;
    NSUInteger  totalPages;
    NSUInteger  currentPageIndex;
    
    NSMutableArray *_flagImages;
    
    dispatch_queue_t _queue;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *countries;
@property (nonatomic, strong) NSMutableArray *filteredCountries;
@property (nonatomic, strong) CountryGeonames *selectedCountry;
@property (nonatomic, strong) ManagedObjectStore *managedObjectStore;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearchBarVisible;

- (IBAction) gotoSearch:(id)sender;
- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end

@implementation RKGeonamesViewController

//@synthesize items;
//@synthesize countries;
//@synthesize filteredCountries;
//@synthesize isSearchBarVisible;
//@synthesize selectedCountry;

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: initWithStyle                                       |+|
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
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: setupSearchBar                                      |+|
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
- (void)setupSearchBar
{
    self.searchBar.delegate = self;
    self.isSearchBarVisible = NO;
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y += self.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: loadFromStorage                                     |+|
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
- (void)loadFromStorage:(NSArray *)cdItems
{
    NSMutableArray *sink = [NSMutableArray arrayWithCapacity:[cdItems count]];
    [cdItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CountryGeonames *cgo = [[CountryGeonames alloc] initWithManagedObject:obj];
        [sink addObject:cgo];
    }];
    
    self.items = [NSArray arrayWithArray:sink];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: loadFlagImages                                      |+|
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
- (void) loadFlagImages;
{
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CountryGeonames *country = obj;
        
        // process flags not cached already
        NSString *flagURL = [NSString stringWithFormat:FLAG_URL, [country.countryCode lowercaseString]];
        
        __block CountryData *countryData = (CountryData *)[[ManagedObjectStore sharedInstance] fetchItem:NSStringFromClass([CountryData class])
                                                                                               predicate:[NSPredicate predicateWithFormat:@"name = %@", country.name]];
        
        __block BOOL flagLoaded = ((countryData != nil) && (countryData.flagData));
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *pictureName = [[flagURL pathComponents] lastObject];
            
            UIImage* image;
            if(NO == flagLoaded)
            {
                __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:flagURL]];
                image = [UIImage imageWithData:imageData];
                
                [RKGeonamesUtils savePictureToDisk:pictureName data:imageData];
                
                //save the flagData member to disk
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ManagedObjectStore sharedInstance] updateItem:NSStringFromClass([CountryData class])
                                                          predicate:[NSPredicate predicateWithFormat:@"name = %@", country.name]
                                                              value:pictureName
                                                                key:@"flagData"];
                });
            }
            else
            {
                NSData *imageData = [RKGeonamesUtils loadPictureFromDisk:countryData.flagData];
                image = [UIImage imageWithData:imageData];
            }

            if(nil != image)
            {
                NSDictionary *newItem = [NSDictionary dictionaryWithObject:image forKey:[country.countryCode lowercaseString]];
                if(nil != newItem)
                    [_flagImages addObject:newItem];
            }
            
            //reload the flags only when loading the first 5 visible
            static const int FIRST_VIIBLE_FLAGS = 10;
            if (idx < FIRST_VIIBLE_FLAGS)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        });
    }];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: saveToCD                                            |+|
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
- (void)saveToDisk:(NSArray *)source
{
    [[ManagedObjectStore sharedInstance] saveData:source completion:^(id obj, NSManagedObjectContext *context) {
        
        CountryData *country = (CountryData *)[[ManagedObjectStore sharedInstance] managedObjectOfType:NSStringFromClass([CountryData class])];
        
        CountryGeonames *rkc = (CountryGeonames *)obj;
        
        [country setValue:rkc.name forKey:@"name"];
        [country setValue:rkc.capitalCity forKey:@"capitalCity"];
        [country setValue:rkc.countryCode forKey:@"iso2Code"];
        [country setValue:rkc.north forKey:@"north"];
        [country setValue:rkc.south forKey:@"south"];
        [country setValue:rkc.east forKey:@"east"];
        [country setValue:rkc.west forKey:@"west"];
        [country setValue:rkc.currency forKey:@"currency"];
        [country setValue:rkc.areaInSqKm forKey:@"surface"];
        
        [context save:nil];
    }];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: loadCoutryDataOfTheWeb                              |+|
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
- (void)loadCoutryDataOfTheWeb:(void (^)(RKObjectRequestOperation *operation, NSArray *result))block
{
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(geonamesCountryMapping)
                                                                               withURL:COUNTRY_INFO_URL
                                                                           pathPattern:nil
                                                                            andKeyPath:@"geonames"];
    
    //load data from the web
    __block RKGeonamesViewController *weakPtr = self;
    
    static NSPredicate *predicate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //sort out countries without a valid capital city name
        predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject capitalCity] length] > 0;
        }];
    });
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        
        NSArray *rkItems = [mappingResult.array filteredArrayUsingPredicate:predicate];
        
        rkItems = [rkItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *countryName1 = [(CountryGeonames *)obj1 name];
            NSString *countryName2 = [(CountryGeonames *)obj2 name];
            
            return [countryName1 compare:countryName2];
        }];
        
        block(operation, rkItems);
        
        [weakPtr.activityIndicator stopAnimating];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        [weakPtr.activityIndicator stopAnimating];
    }];
    
    [operation start];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: getGeonamesCountries                                |+|
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
static NSString * const COUNTRY_INFO_URL = @"http://api.geonames.org/countryInfoJSON?username=sbpuser";
- (void) getGeonamesCountries:(id)sender
{
    void (^setupBlock)(void) = ^{
        //array to hold the countries when using the search bar control
        self.filteredCountries = [NSMutableArray arrayWithCapacity:[self.items count]];
        _flagImages = [NSMutableArray arrayWithCapacity:[self.items count]];
        
        NSLog(@"Before loading the flags");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self
                                                  action:@selector(gotoSearch:)];
        
        [self loadFlagImages];
    };
    
    NSArray *locallyStoredItems = [[ManagedObjectStore sharedInstance] allItems:NSStringFromClass([CountryData class])];
    
    //load data from the disk
    if([locallyStoredItems count] > 0)
    {
        [self loadFromStorage:locallyStoredItems];
        
        setupBlock();
        
        [self.activityIndicator stopAnimating];
        
        //load from the web and if new items available merge them in the main storage
        //update the gui
        
        __block RKGeonamesViewController *weakPtr = self;
        
        //update the local storage with data from the web
        [self loadCoutryDataOfTheWeb:^(RKObjectRequestOperation *operation, NSArray *result) {
            
            NSArray *compareResult = [weakPtr.items compare:result];
            if(compareResult == weakPtr.items)
            {
                return;
            }
            
            [[ManagedObjectStore sharedInstance] removeAll:NSStringFromClass([CountryData class])];
            [weakPtr saveToDisk:compareResult];
            weakPtr.items = compareResult;

            self.filteredCountries = [NSMutableArray arrayWithCapacity:[self.items count]];
            _flagImages = [NSMutableArray arrayWithCapacity:[self.items count]];
            
            [self loadFlagImages];
        }];
        
        return ;
    }
    
    //load data from the web
    __block RKGeonamesViewController *weakPtr = self;
    
    [self loadCoutryDataOfTheWeb:^(RKObjectRequestOperation *operation, NSArray *result) {
        
        weakPtr.items = result;
        
        [weakPtr saveToDisk:weakPtr.items];
        
        setupBlock();
    }];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didSelectRowAtIndexPath                             |+|
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
- (void)viewWillAppear:(BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RKGSplashScreenViewController *splashScreenViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
        
        splashScreenViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        splashScreenViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentModalViewController:splashScreenViewController animated:NO];
    });
    
    [super viewWillAppear:animated];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didSelectRowAtIndexPath                             |+|
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        self.selectedCountry = [self.filteredCountries objectAtIndex:indexPath.row];
        
        [self.searchDisplayController setActive:NO animated:YES];
    }
    
    [self performSegueWithIdentifier:@"CountryDetailsSegue" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: prepareForSegue                                     |+|
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(YES == [segue.identifier isEqualToString:@"CountryDetailsSegue"])
    {
        if(nil == self.selectedCountry)
        {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            
            self.selectedCountry = [self.items objectAtIndex:path.row];
        }
        
        [segue.destinationViewController setDetails:self.selectedCountry];
        [_flagImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImage *image = [obj objectForKey:[self.selectedCountry.countryCode lowercaseString]];
            if(nil != image)
            {
                [segue.destinationViewController setBackgroundImage:image];
                *stop = YES;
            }
        }];
        
        self.selectedCountry = nil;
    }
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: viewDidLoad                                         |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   Do any additional setup after loading the view      |+|
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
- (void)viewDidLoad
{
    [super viewDidLoad];

    // add the "Back" button to the navigation bar
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                             style:UIBarButtonItemStyleBordered
                                                             target:nil
                                                             action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                              target:self
                                              action:@selector(getGeonamesCountries:)];
    
    [self setupSearchBar];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
    
    [self.tableView registerClass:[RKGeonamesTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.managedObjectStore = [ManagedObjectStore sharedInstance];
    
//    [[ManagedObjectStore sharedInstance] removeAll:NSStringFromClass([CountryData class])];
    
    [self getGeonamesCountries:nil];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: numberOfSectionsInTableView                         |+|
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: numberOfRowsInSection                               |+|
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filteredCountries count];
    }
    
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (RKGeonamesTableViewCell *)decorateCell:(RKGeonamesTableViewCell *)cell withCountryProperties:(CountryGeonames *)country
{
    cell.countryNameLabel.text = country.name;
    cell.capitalCityLabel.text = country.capitalCity;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
//    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure.png"]];
    
    __block UIImage *flagImage;
    
    // we cache the flags to improve performance
    [_flagImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // when a flag has been cached already
        // we just load it and return
        if (nil != (flagImage = [obj objectForKey:[country.countryCode lowercaseString]]))
        {
            cell.flagImage.image = flagImage;
//            cell.contentView.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
            
            *stop = YES;
            
            return ;
        }
    }];
    
    return cell;
}

//0 % 5 -> 0
//1 % 5 -> 1
//2 % 5 -> 2
//3 % 5 -> 3
//4 % 5 -> 4
//
//5 % 5 -> 4
//6 % 5 -> 3
//7 % 5 -> 2
//8 % 5 -> 1
//9 % 5 -> 0
//
//10 % 5 -> 0
//11 % 5 -> 1
//12 % 5 -> 2
//13 % 5 -> 3
//14 % 5 -> 4
//
//15 % 5 -> 4
//16 % 5 -> 3
//17 % 5 -> 2
//18 % 5 -> 1
//19 % 5 -> 0

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: cellForRowAtIndexPath                               |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   display the country's name, flag and capital        |+|
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
- (UIColor *)colorForIndex:(NSInteger)index
{
    NSUInteger itemCount = self.items.count - 1;
    float indexDiv = index % 10;
    if (indexDiv >= 5)
    {
        indexDiv = 10 - indexDiv - 1;
    }
    
    float val = ((float)indexDiv/(float)itemCount)*5;
    
    return [UIColor colorWithRed:(val+.85) green:0.925f blue:.975f alpha:1];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

#define GRADIENT_COLOR_1    [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0] CGColor]
#define GRADIENT_COLOR_2    [[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] CGColor]

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: cellForRowAtIndexPath                               |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   display the country's name, flag and capital        |+|
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
static NSString *const FLAG_URL = @"http://www.geonames.org/flags/x/%@.gif";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RKGeonamesTableViewCell";
    __block RKGeonamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(nil == cell)
    {
        cell = [[RKGeonamesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    CountryGeonames *country = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        country = [self.filteredCountries objectAtIndex:indexPath.row];
        
        return [self decorateCell:cell withCountryProperties:country];
    }
    else
    {
        country = [self.items objectAtIndex:indexPath.row];
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        __block UIImage *flagImage;
        
        // we cache the flags to improve performance
        [_flagImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         
            // when a flag has been cached already
            // we just load it and return
            if (nil != (flagImage = [obj objectForKey:[country.countryCode lowercaseString]]))
            {
                cell.flagImage.image = flagImage;
                
                *stop = YES;
                
                return ;
            }
        }];
        
        if(nil != flagImage)
        {
            return cell;
        }
        
        NSLog(@"flagImage == nil");
        
        static UIImage *bandanaFlag = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bandanaFlag = [UIImage imageNamed:@"bandanaflag.jpg"];
        });
        
        cell.flagImage.image = bandanaFlag;
        
        if(nil != country)
        {
            __block CountryData *countryData = (CountryData *)[[ManagedObjectStore sharedInstance] fetchItem:NSStringFromClass([CountryData class])
                                                                                                   predicate:[NSPredicate predicateWithFormat:@"name = %@", country.name]];
            
            if(nil != countryData && countryData.flagData != nil)
            {
                NSData *imageData = [RKGeonamesUtils loadPictureFromDisk:countryData.flagData];
                UIImage *image = [UIImage imageWithData:imageData];
                NSDictionary *newItem = [NSDictionary dictionaryWithObject:image forKey:[country.countryCode lowercaseString]];
                if(nil != newItem)
                {
                    [_flagImages addObject:newItem];
                }
                
                cell.flagImage.image = image;
            }
        }
    }
    
    return cell;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: updateView                                          |+|
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
- (void)updateView;
{
    [self.tableView reloadData];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: gotoSearch                                          |+|
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
- (IBAction)gotoSearch:(id)sender
{
    [self.tableView scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
    
    if(NO == self.isSearchBarVisible)
    {
        self.isSearchBarVisible = YES;
    }
    
    [self.searchBar becomeFirstResponder];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: filterContentForSearchText                          |+|
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
- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    // Update the filtered array based on the search text and scope
    
    // Remove all objects from the filtered array
    [self.filteredCountries removeAllObjects];
    
    //filter the array using the NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    self.filteredCountries = [NSMutableArray arrayWithArray:[self.items filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController delegate methods
// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: filterContentForSearchText                          |+|
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
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // tells the table data to reload when the text changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: searchDisplayController                             |+|
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
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

@end
