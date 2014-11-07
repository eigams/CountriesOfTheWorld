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

- (NSArray *)compare:(NSArray *)source;
{
    if(nil == source || [source count] < 1) {
        return nil;
    }
    
    //save a copy to process later
    NSMutableArray *snapshot = [self mutableCopy];
    
    NSMutableSet *sourceSet = [NSMutableSet set];
    
    for (CountryGeonames *obj in source) {
        [sourceSet addObject:obj.name];
    }
    
    NSMutableSet *selfSet = [NSMutableSet setWithCapacity:[self count]];
    for(CountryGeonames *obj in self){
        [selfSet addObject:obj.name];
    }
    
    NSSet *setSnapshot = [NSSet setWithSet:selfSet];
    
    //compare sets to determine possible differences
    [selfSet minusSet:sourceSet];
    if([selfSet count] == 0) {
        return self;
    }
    
    if ([selfSet count] > 0) {
        
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CountryGeonames *cg = (CountryGeonames *)obj;
            if ([selfSet containsObject:cg.name]) {
                [snapshot removeObject:cg];
            }
        }];
        
        return [NSArray arrayWithArray:snapshot];
    }
    
    [sourceSet minusSet:setSnapshot];
    if ([sourceSet count] > 0) {
        
        [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CountryGeonames *cg = (CountryGeonames *)obj;
            if ([sourceSet containsObject:cg.name]) {
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

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearchBarVisible;
@property (nonatomic, weak) RKGeonamesDataController *dataController;

- (IBAction) gotoSearch:(id)sender;
- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end

@implementation RKGeonamesViewController

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
- (void) getGeonamesCountries:(id)sender
{
    void (^setupBlock)(void) = ^{
        
        NSLog(@"Before loading the flags");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self
                                                  action:@selector(gotoSearch:)];
        
        _flagImages = [self.dataController loadFlags];
    };
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
    NSArray *locallyStoredItems = [[ManagedObjectStore sharedInstance] allItems:NSStringFromClass([CountryData class])];
    
    //load data from the disk
    if([locallyStoredItems count] > 0) {
        
        self.items = [self.dataController loadFromStorage:locallyStoredItems];
        
        setupBlock();
        
        [self.activityIndicator stopAnimating];
        
        //load from the web and if new items available merge them in the main storage
        //update the gui
        
        __block RKGeonamesViewController *weakPtr = self;
        
        //update the local storage with data from the web
        [self.dataController loadRemoteData:^(NSArray *result) {
            
            NSArray *compareResult = [weakPtr.items compare:result];
            if(compareResult == weakPtr.items) {
                return;
            }
            
            _flagImages = [self.dataController loadFlags];
            
            [weakPtr.activityIndicator stopAnimating];
        } failure:^(NSError *error){
            
            [weakPtr.activityIndicator stopAnimating];
        }];
        
        return ;
    }
    
    //load data from the web
    __block RKGeonamesViewController *weakPtr = self;
    
    [self.dataController loadRemoteData:^(NSArray *result) {
        
        weakPtr.items = result;
        
        [self.dataController loadFromStorage:result];
        
        setupBlock();
        
        [weakPtr.activityIndicator stopAnimating];
    } failure:^(NSError *error){
        
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
static NSString *const SPLASHSCREEN_VIEWCONTROLLER = @"SplashScreenViewController";
- (void)viewWillAppear:(BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RKGSplashScreenViewController *splashScreenViewController = [self.storyboard instantiateViewControllerWithIdentifier:SPLASHSCREEN_VIEWCONTROLLER];

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
        self.selectedCountry = [self.items objectAtIndex:indexPath.row];
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

- (NSIndexPath *)indexPathForCountry:(NSString *)countryCode {
    if(nil == countryCode || [countryCode length] < 1) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    if(nil == self.items || [self.items count] < 1) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    __block NSUInteger countryIndex = 0;
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *localCountryCode = [(CountryGeonames *)obj countryCode];
        if(YES == [countryCode isEqualToString:[localCountryCode lowercaseString]]) {
            countryIndex = idx;
            
            *stop = YES;
        }
    }];
    
    return [NSIndexPath indexPathForRow:countryIndex inSection:0];
}

- (void)selectCountry:(NSString *)countryCode {
    
    NSIndexPath *indexPath = [self indexPathForCountry:countryCode];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

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
