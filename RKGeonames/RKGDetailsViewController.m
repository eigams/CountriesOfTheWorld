//
//  RKGDetailsViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGDetailsViewController.h"

#import "RKGeonamesUtils.h"
#import "RKGeonamesConstants.h"
#import "CountryData.h"

@interface RKGDetailsViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImage *bgImage;

@end

@implementation RKGDetailsViewController

@synthesize country;

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: setDetails                                          |+|
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
- (void) setDetails:(CountryGeonames *)Country
{
    self.country = Country;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: initWithNibName                                     |+|
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: setupMapView                                        |+|
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
static NSString *MAP_VIEW_URL = @"http://maps.google.com/maps/api/staticmap?size=320x150&&sensor=false&path=weight:3|fillcolor:|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f";
static const NSUInteger INDICATOR_WIDTH = 30;
static const NSUInteger INDICATOR_HEGHT = 30;
- (void) setupMapView
{
    float lah = [self.country.north floatValue] + .5,
          lal = [self.country.south floatValue] - .5,
          loh = [self.country.east floatValue] + .5,
          lol = [self.country.west floatValue] - .5;
    
    NSString *urlString = [NSString stringWithFormat:MAP_VIEW_URL, lah, loh, lah, lol, lal, lol, lal, loh, lah, loh];
    
    NSLog(@"urlString: %@", urlString);
    
    self.mapView.delegate = self;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(self.mapView.frame.size.width/2 - INDICATOR_WIDTH/2,
                                                                                        self.mapView.frame.size.height/2 + INDICATOR_HEGHT/2,
                                                                                        INDICATOR_WIDTH, INDICATOR_HEGHT)];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.mapView addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView loadRequest:urlRequest];
            self.mapView.alpha = 1;
        });
    });
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: setBackgroundImage                                  |+|
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
static NSString *COUNTRY_FLAG_URL = @"http://www.geonames.org/flags/x/%@.gif";
static const NSUInteger FLAG_Y_POS = 211;
static const NSUInteger FLAG_WIDTH = 320;
static const NSUInteger FLAG_HEIGHT = 211;
- (void)setBackgroundImage:(UIImage *)image
{
    self.bgImage = image;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.bgImage];

    imageView.frame = CGRectMake(0, FLAG_Y_POS, FLAG_WIDTH, self.view.frame.size.height - FLAG_HEIGHT);
    imageView.alpha = 0.1;
    imageView.contentMode = UIViewContentModeScaleToFill;

    [self.view addSubview:imageView];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|`
// |+|    FUNCTION NAME: addHomeButton                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:  adds a "Home" button to a navigation bar             |+|
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
- (void)addHomeButton:(id)target selector:(SEL)action;
{
    // add the "Back" button to the navigation bar
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:target
                                                                  action:action];
    self.navigationItem.rightBarButtonItem = barButton;
}

//message number 3

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: navigateHome                                        |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION: this is the function associated wih the "Home" button |+|
// |+|               on the navigation bar, gets the user to the main screen |+|
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
static const int HOME_VIEW_INDEX = 3;
- (void) navigateHome;
{
    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:(noOfViewControllers - HOME_VIEW_INDEX)];
    [self.navigationController popToViewController:vc animated:YES];

    if([vc respondsToSelector:@selector(updateView)])
    {
        [vc performSelector:@selector(updateView)];
    }
}

//just some test message
//some more test messages

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: addBarButtons                                       |+|
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
- (void)addBarButtons:(SEL)refreshSelector
{
//    [self addHomeButton];
    // add the "Back" button to the navigation bar
    UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(navigateHome)];
    
    // add the "Back" button to the navigation bar
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                target:self
                                                                                action:refreshSelector];
    
    self.navigationItem.rightBarButtonItems = @[homeBarButton, refreshBarButton];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: addHomeButton                                       |+|
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
- (void)addHomeButton;
{
    [self addHomeButton:self selector:@selector(navigateHome)];
}

- (void)setupTextFieldView
{
    return;
}

static NSString *YEAR_TEXT = @"";

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: viewDidLoad                                         |+|
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
    
    [self setupMapView];
    
    self.title = self.country.name;

    [self setupTextFieldView];
    
	// Do any additional setup after loading the view.
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
    [segue.destinationViewController setDetails:self.country];
    [segue.destinationViewController setBackgroundImage:self.bgImage];
}

#pragma mark - UITableView delegates

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: numberOfRowsInSection                               |+|
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentData[@"titles"] count];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: cellForRowAtIndexPath                               |+|
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
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentData[@"values"][indexPath.row];
    if(YES == [currentData[@"values"][indexPath.row] isEqualToString:LOADING_STRING])
    {
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)cell.accessoryView;
        if(nil != spinner)
        {
            return cell;
        }
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0, 0, 14, 14);
        
        cell.accessoryView = spinner;
        
        [spinner startAnimating];
    }
    else
    {
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)cell.accessoryView;
        
        NSLog(@"cell.detailTextLabel.text: %@", cell.detailTextLabel.text);
        
        [spinner stopAnimating];
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - UIWebViewDelegates

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: webViewDidFinishLoad                                |+|
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
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

@end
