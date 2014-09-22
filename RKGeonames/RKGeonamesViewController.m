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

#import "RKGeonames-Swift.h"

//#import "MSCellAccessory.h"

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
    if ([setSource count] > 0) {
        
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

@interface RKGeonamesViewController () <UIViewControllerTransitioningDelegate>
{
    NSUInteger  totalCountries;
    NSUInteger  totalPages;
    NSUInteger  currentPageIndex;
    
    NSDictionary *_flagImages;
    
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
@property (nonatomic, weak) RKGeonamesDataController *dataController;

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
        
        NSString *tmp = NSStringFromClass([CountryData class]);
        
        NSArray *items = [[ManagedObjectStore sharedInstance] allItems:NSStringFromClass([CountryData class])];
        
        items = items;
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
- (void)loadCoutryDataOfTheWeb:(void (^)(NSArray *result))success failure:(void (^)())failure {
    
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
        
        success(rkItems);
        
        [weakPtr.activityIndicator stopAnimating];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        failure();
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
//        self.filteredCountries = [NSMutableArray arrayWithCapacity:[self.items count]];
//        _flagImages = [NSMutableArray arrayWithCapacity:[self.items count]];
        
        NSLog(@"Before loading the flags");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self
                                                  action:@selector(gotoSearch:)];
        
//        [self loadFlagImages];
        _flagImages = [self.dataController loadFlags];
    };
    
    NSArray *locallyStoredItems = [[ManagedObjectStore sharedInstance] allItems:NSStringFromClass([CountryData class])];
    
    //load data from the disk
    if([locallyStoredItems count] > 0)
    {
        //[self loadFromStorage:locallyStoredItems];
        self.items = [self.dataController loadFromStorage:locallyStoredItems];
        
        setupBlock();
        
        [self.activityIndicator stopAnimating];
        
        //load from the web and if new items available merge them in the main storage
        //update the gui
        
        __block RKGeonamesViewController *weakPtr = self;
        
        //update the local storage with data from the web
        [self loadCoutryDataOfTheWeb:^(NSArray *result) {
            
            NSArray *compareResult = [weakPtr.items compare:result];
            if(compareResult == weakPtr.items) {
                return;
            }
            
            [[ManagedObjectStore sharedInstance] removeAll:NSStringFromClass([CountryData class])];
            [weakPtr saveToDisk:compareResult];
            weakPtr.items = compareResult;
            
            _flagImages = [self.dataController loadFlags];
            
            [weakPtr.activityIndicator stopAnimating];
        } failure:^{
            
            [weakPtr.activityIndicator stopAnimating];
        }];
        
        return ;
    }
    
    //load data from the web
    __block RKGeonamesViewController *weakPtr = self;
    
    [self loadCoutryDataOfTheWeb:^(NSArray *result) {
        
        weakPtr.items = result;
        
        [self.dataController loadFromStorage:result];
        
        setupBlock();
    } failure:^{
        
        [weakPtr.activityIndicator stopAnimating];
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

static const NSUInteger CELL_HEIGHT = 90;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
        self.selectedCountry = [self.dataController.filteredCountries objectAtIndex:indexPath.row];
        
        [self.searchDisplayController setActive:NO animated:YES];
    } else {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        self.selectedCountry = [self.items objectAtIndex:path.row];
    }
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryDetails"];
    [vc performSelector:@selector(setTransitioningDelegate:) withObject:self];
    [vc performSelector:@selector(setDetails:) withObject:self.selectedCountry];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    self.dataController = self.tableView.dataSource;
    self.dataController.tableView = self.tableView;
    self.dataController.searchDisplayController = self.searchDisplayController;

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
// |+|    FUNCTION NAME: colorForIndex                                       |+|
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
- (UIColor *)colorForIndex:(NSInteger)index {
    
    NSUInteger itemCount = self.items.count - 1;
    float indexDiv = index % 10;
    if (indexDiv >= 5) {
        indexDiv = 10 - indexDiv - 1;
    }
    
    float valR = ((float)indexDiv/(float)itemCount)*4;
    float valG = ((float)indexDiv/(float)itemCount)*3;
    
    return [UIColor colorWithRed:(valR+.86f) green:(valG + 0.93f) blue:1 alpha:1];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

#define GRADIENT_COLOR_1    [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0] CGColor]
#define GRADIENT_COLOR_2    [[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] CGColor]


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
- (IBAction)gotoSearch:(id)sender {
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    if(NO == self.isSearchBarVisible) {
        
        self.isSearchBarVisible = YES;
    }
    
    [self.searchBar becomeFirstResponder];
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
    [self.dataController searchDisplayController:controller shouldReloadTableForSearchScope:searchOption];
    
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
    [self.dataController searchDisplayController:controller shouldReloadTableForSearchString: searchString];
    
    return YES;
}

@end
