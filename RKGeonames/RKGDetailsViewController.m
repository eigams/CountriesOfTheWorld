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
#import "RKGeonames-Swift.h"

#import "RKGWebView.h"

@interface RKGDetailsViewController ()<RKGWebViewDelegate>

@property (nonatomic, strong) UIImage *bgImage;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

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
- (void) setDetails:(CountryGeonames *)Country {
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
        _zoomedIn = NO;
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
static NSString *MAP_VIEW_URL = @"http://maps.google.com/maps/api/staticmap?size=%ux%u&&sensor=false&path=weight:3|fillcolor:|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f&scale=4";
static const NSUInteger INDICATOR_WIDTH = 30;
static const NSUInteger INDICATOR_HEGHT = 30;
- (void) setupMapView {
    self.mapView.delegate = self;
    self.mapView.rkgdelegate = self;
//    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(self.mapView.frame.size.width/2 - INDICATOR_WIDTH/2,
//                                                                                        self.mapView.frame.size.height/2 + INDICATOR_HEGHT/2,
//                                                                                        INDICATOR_WIDTH, INDICATOR_HEGHT)];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.mapView addSubview:self.activityIndicator];

    // Center horizontally
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[label]"
                                                                     options: NSLayoutFormatAlignAllCenterX
                                                                     metrics: nil
                                                                       views: @{@"superview":self.mapView, @"label":self.activityIndicator}];
    
    [self.mapView addConstraints:constraints];
    
    // Center vertically
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[label]"
                                                                   options: NSLayoutFormatAlignAllCenterY
                                                                   metrics: nil
                                                                     views: @{@"superview":self.mapView, @"label":self.activityIndicator}];
    
    [self.mapView addConstraints:constraints];
    
    [self.activityIndicator startAnimating];
    
    self.mapView.scalesPageToFit = YES;
    [self.mapView loadRequest:[self mapNoZoom]];
    self.mapView.alpha = 1;
    
}

- (NSURLRequest *)mapURLRequest:(NSUInteger)width height:(NSUInteger)height {
    
    float lah = [self.country.north floatValue] + .5,
    lal = [self.country.south floatValue] - .5,
    loh = [self.country.east floatValue] + .5,
    lol = [self.country.west floatValue] - .5;
    
    NSString *urlString = [NSString stringWithFormat:MAP_VIEW_URL, width, height, lah, loh, lah, lol, lal, lol, lal, loh, lah, loh];
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSURLRequest *)mapZoomIn {
    static const NSUInteger ZOOMIN_WIDTH = 570;
    static const NSUInteger ZOOMIN_HEIGHT = 570;
    
    return [self mapURLRequest:ZOOMIN_WIDTH height:ZOOMIN_HEIGHT];
}

- (NSURLRequest *)mapNoZoom {
    static const NSUInteger NOZOOM_WIDTH = 5700;
    static const NSUInteger NOZOOM_HEIGHT = 5700;
    
    return [self mapURLRequest:NOZOOM_WIDTH height:NOZOOM_HEIGHT];
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
- (void)setBackgroundImage:(UIImage *)image {
    self.bgImage = image;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.bgImage];

    imageView.frame = CGRectMake(0, FLAG_Y_POS, FLAG_WIDTH, self.view.frame.size.height - FLAG_HEIGHT);
    imageView.alpha = 0.1;
    imageView.contentMode = UIViewContentModeScaleToFill;

    [self.view addSubview:imageView];
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
- (UIBarButtonItem *)addHomeButton:(id)target selector:(SEL)action {
    
    UIImage *image = [[UIImage imageNamed:@"home_icon.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    CGSize newSize;
    newSize.width = 25;
    newSize.height = 25;
    
    // add the "Home" button to the navigation bar
    UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc] initWithImage:[[self class] imageWithImage:image scaledToSize:newSize]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:target
                                                                 action:action];
    self.navigationItem.rightBarButtonItem = homeBarButton;
    
    return homeBarButton;
}

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
- (void) navigateHome {
    
    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:(noOfViewControllers - HOME_VIEW_INDEX)];
    [self.navigationController popToViewController:vc animated:YES];

    if([vc respondsToSelector:@selector(updateView)]) {
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
    UIBarButtonItem *homeBarButton = [self addHomeButton];
    // add the "Back" button to the navigation bar
//    UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
//                                                                  style:UIBarButtonItemStyleBordered
//                                                                 target:self
//                                                                 action:@selector(navigateHome)];
    
    // add the "Back" button to the navigation bar
//    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
//                                                                                target:self
//                                                                                action:refreshSelector];
    
    self.navigationItem.rightBarButtonItems = @[homeBarButton];
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
- (UIBarButtonItem *)addHomeButton {
    return [self addHomeButton:self selector:@selector(navigateHome)];
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
    
//    NSDictionary *variables = NSDictionaryOfVariableBindings(self.activityIndicator, self.mapView);
//    NSArray *constraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[mapView]-(<=1)-[activityIndicator]"
//                                            options: NSLayoutFormatAlignAllCenterX
//                                            metrics:nil
//                                              views:variables];
//    [self.view addConstraints:constraints];
//    
//    constraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[mapView]-(<=1)-[activityIndicator]"
//                                            options: NSLayoutFormatAlignAllCenterY
//                                            metrics:nil
//                                              views:variables];
//    [self.view addConstraints:constraints];
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
static NSString *const CELLNAME = @"cell";
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELLNAME];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLNAME];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = currentData[@"titles"][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
    cell.detailTextLabel.text = currentData[@"values"][indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    if(YES == [currentData[@"values"][indexPath.row] isEqualToString:LOADING_STRING]) {
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)cell.accessoryView;
        if(nil != spinner) {
            return cell;
        }
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0, 0, 14, 14);
        
        cell.accessoryView = spinner;
        
        [spinner startAnimating];
    }
    else {
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)cell.accessoryView;
        
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

- (void)zoomInWithAffine {
    [UIView animateWithDuration:0.5 animations:^{
        self.mapView.transform = CGAffineTransformScale(self.mapView.transform, 2, 3);
    }];
}

- (void)zoomOutWithAffine {
    [UIView animateWithDuration:0.5 animations:^{
        self.mapView.transform = CGAffineTransformScale(self.mapView.transform, .5, .33);
    }];
}

- (void)setupControlsWithZoom:(BOOL)zoomIn {
    
}

static BOOL _zoomedIn = NO;
- (void)didDoubleTapWebView {
  
    if(_zoomedIn) {
        [self zoomOutWithAffine];
    } else {
        [self zoomInWithAffine];
    }
  
//    [self.mapView loadRequest:[self mapNoZoom]];
    [self.mapView loadRequest:_zoomedIn ? [self mapNoZoom] : [self mapZoomIn]];
    
    [self setupControlsWithZoom:_zoomedIn];
    
//    self.
    _zoomedIn = !_zoomedIn;
    self.mapView.alpha = 1;
}

@end
