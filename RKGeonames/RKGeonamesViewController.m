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
- (void) getGeonamesCountries
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/countryInfoJSON?username=sbpuser"];

    RKObjectRequestOperation *operation = [RKGeonamesUtils setupObjectRequestOperation:@selector(geonamesCountryMapping) withURL:urlString andPathPattern:nil andKeyPath:@"geonames"];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        self.items = mappingResult.array;
        
        self.filteredCountries = [NSMutableArray arrayWithCapacity:[self.items count]];
        
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
        
        self.selectedCountry = nil;
    }
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
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupSearchBar];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
    
    [self getGeonamesCountries];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
#warning Potentially incomplete method implementation.
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
#warning Incomplete method implementation.
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
        cell.contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:244.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
    else
    {
        country = [self.items objectAtIndex:indexPath.row];
        
        cell.countryNameLabel.text = country.name;
        cell.capitalCityLabel.text = country.capitalCity;
        
        NSString *flagURL = [NSString stringWithFormat:@"http://www.geonames.org/flags/x/%@.gif", [country.countryCode lowercaseString]];
        
        cell.flagImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:flagURL]]];
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:244.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Table view delegate

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: collect                                             |+|
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
