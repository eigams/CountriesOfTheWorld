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
//#import "RKGSplashScreenViewController.h"
#import "RKCountryDetailsViewController.h"
#import "UINavigationItem+RKGeonames.h"

#import "RKGeonamesUtils.h"

//#import "ManagedObjectStore.h"
//#import "CountryData.h"

#import "CountriesOfTheWorld-Swift.h"

@interface RKGeonamesViewController () <UIViewControllerTransitioningDelegate> {
    
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

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearchBarVisible;
@property (nonatomic, weak) IBOutlet RKGeonamesDataController *dataController;


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

- (void)setRemoteLoadedResults:(NSArray *)results {
    
    __weak RKGeonamesViewController *weakSelf = self;
    
    void (^setupBlock)(void) = ^{
        
        NSLog(@"Before loading the flags");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:weakSelf
                                                  action:@selector(gotoSearch:)];
        
        _flagImages = [self.dataController loadFlags:^(){
            
            if(self.selectedCountry) {
                [self setImageFlag];
            }
            
        }];
    };
    
    self.items = results;
    
    [self.dataController setCountries:results];
    
    setupBlock();
    
    [self.tableView reloadData];
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

static const NSUInteger CELL_HEIGHT = 130;
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
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    cell.accessoryView = spinner;
    [spinner startAnimating];
    [self performSelector:@selector(pushDetailedController:) withObject:@[tableView, indexPath] afterDelay:0.1];
}

- (void)pushDetailedController:(NSArray *)params {
    
    UIViewController *countryDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryDetails"];
    [self setImageFlag];
    [countryDetailsViewController performSelector:@selector(setCountry:) withObject:self.selectedCountry];
    
    UITableView *tableView = (UITableView *)[params firstObject];
    NSIndexPath *indexPath = (NSIndexPath *)[params lastObject];
    
    [self.navigationController pushViewController:countryDetailsViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)cell.accessoryView;
    [spinner stopAnimating];
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
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavigationBarTitle];
    [self setupSearchBar];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
    
    [self.tableView registerClass:[RKGeonamesTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.dataController = self.tableView.dataSource;
    self.dataController.tableView = self.tableView;
    self.dataController.searchDisplayController = self.searchDisplayController;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _flagImages = [self.dataController loadFlags:^(){
            [self setImageFlag];
        }];
    });
    
    [self.tableView reloadData];
}

- (CountryGeonames *)setImageFlag {
    _flagImages = [self.dataController imageFlags];
//    NSIndexPath *index = [self indexPathForCountry:countryCode];
//    CountryGeonames *country = [self.items objectAtIndex:index.row];
//    country.flag = _flagImages[countryCode];
    
    if(self.selectedCountry) {
        self.selectedCountry.flag = _flagImages[self.selectedCountry.countryCode];
    }
    
    return self.selectedCountry;
}

- (void)setNavigationBarTitle {

//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    shadow.shadowOffset = CGSizeMake(0, 1);
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
//                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14.0], NSFontAttributeName, nil]];
//    self.navigationItem.title = @"COUNTRIES OF THE WORLD";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    label.shadowColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:1.0 alpha:0.85];
    self.navigationItem.titleView = label;
    label.text = @"COUNTRIES OF THE WORLD";
    [label sizeToFit];
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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static const CGFloat WHITE_VIEW_XPOS = 10;
static const CGFloat WHITE_VIEW_YPOS = 10;
static const CGFloat WHITE_VIEW_WIDTH_DELTA = 20;
static const CGFloat WHITE_VIEW_HEIGHT = 111;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.backgroundColor = [self colorForIndex:indexPath.row];
//    cell.backgroundColor = UIColorFromRGB(0xF3F4F8);
    
    RKGeonamesTableViewCell *masterCell = (RKGeonamesTableViewCell *)cell;
    
    if(masterCell.whiteRoundedView) {
        [masterCell.whiteRoundedView removeFromSuperview];
        masterCell.whiteRoundedView = nil;
    }
    
    masterCell.backgroundColor = [UIColor clearColor];
    masterCell.selectionStyle = UITableViewCellSelectionStyleNone;
    masterCell.contentView.backgroundColor = [UIColor clearColor];
    masterCell.whiteRoundedView = [[UIView alloc] initWithFrame:CGRectMake(WHITE_VIEW_XPOS, WHITE_VIEW_YPOS, self.view.frame.size.width - WHITE_VIEW_WIDTH_DELTA, WHITE_VIEW_HEIGHT)];
    CGFloat components[] = { 1.0, 1.0f, 1.0f, 1.f };
    CGColorRef backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), components);
    masterCell.whiteRoundedView.layer.backgroundColor = backgroundColor;
    CGColorRelease(backgroundColor);
    masterCell.whiteRoundedView.layer.masksToBounds = NO;
    masterCell.whiteRoundedView.layer.shadowOffset = CGSizeMake(0, 1);
    masterCell.whiteRoundedView.layer.shadowOpacity = 0.5;
    [masterCell.contentView addSubview:masterCell.whiteRoundedView];
    [masterCell.contentView sendSubviewToBack:masterCell.whiteRoundedView];
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
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
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
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self.dataController searchDisplayController:controller shouldReloadTableForSearchString: searchString];
    
    return YES;
}

#pragma mark - NSFetchControllerDelegate methods

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
