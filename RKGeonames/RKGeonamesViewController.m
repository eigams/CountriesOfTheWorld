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


@interface RKGeonamesViewController ()
{
    NSUInteger  totalCountries;
    NSUInteger  totalPages;
    NSUInteger  currentPageIndex;
    
    NSMutableSet *_flagImages;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *countries;
@property (nonatomic, strong) NSMutableArray *filteredCountries;
@property (nonatomic, strong) CountryGeonames *selectedCountry;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearchBarVisible;

- (IBAction) gotoSearch:(id)sender;
- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

- (void) setupSearchBar:(id)sender;

@end

@implementation RKGeonamesViewController

@synthesize items;
@synthesize countries;
@synthesize filteredCountries;
@synthesize isSearchBarVisible;
@synthesize selectedCountry;

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
static NSString *COUNTRY_INFO_URL = @"http://api.geonames.org/countryInfoJSON?username=sbpuser";
- (void) getGeonamesCountries
{
    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(geonamesCountryMapping) withURL:COUNTRY_INFO_URL andPathPattern:nil andKeyPath:@"geonames"];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        
        //eliminate all countries without a capital city
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject capitalCity] length] > 0;
        }];
        self.items = [mappingResult.array filteredArrayUsingPredicate:predicate];
        
        //array to hold the countries when using the search bar control
        self.filteredCountries = [NSMutableArray arrayWithCapacity:[self.items count]];
        _flagImages = [NSMutableSet setWithCapacity:[self.items count]];
        
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        
        [self.activityIndicator stopAnimating];
    }];
    
    [operation start];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    
}

static BOOL firstTime = YES;

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
    if(YES == firstTime)
    {
        RKGSplashScreenViewController *splashScreenViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
        
        splashScreenViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        splashScreenViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentModalViewController:splashScreenViewController animated:NO];
        
        firstTime = NO;
    }
    
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
        
        [self performSegueWithIdentifier:@"CountryDetailsSegue" sender:self];
        
        [self.searchDisplayController setActive:NO animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        [_flagImages enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
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
    
    [self setupSearchBar];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
    
    [self getGeonamesCountries];
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
    else
    {
        return [self.items count];
    }
}

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
static NSString *FLAG_URL = @"http://www.geonames.org/flags/x/%@.gif";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RKGeonamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell)
    {
        cell = [[RKGeonamesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CountryGeonames *country = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        country = [self.filteredCountries objectAtIndex:indexPath.row];
        
        cell.textLabel.text = country.name;
    }
    else
    {
        country = [self.items objectAtIndex:indexPath.row];
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;
        
        UIImage *flagImage;
        
        // we cache the flags to improve performance
        for (NSDictionary *item in _flagImages)
        {
            // when a flag has been cached already
            // we just load it and return
            if (nil != (flagImage = [item objectForKey:[country.countryCode lowercaseString]]))
            {
                cell.flagImage.image = flagImage;
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
                
                return cell;
            }
        }
        
        cell.flagImage.image = [UIImage imageNamed:@"bandanaflag.jpg"];
        
        // process flags not cached already
        NSString *flagURL = [NSString stringWithFormat:FLAG_URL, [country.countryCode lowercaseString]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:flagURL]]];
            NSDictionary *newItem = [NSDictionary dictionaryWithObject:image forKey:[country.countryCode lowercaseString]];
            [_flagImages addObject:newItem];
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.flagImage.image = image;
            });
        });
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    
    return cell;
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
