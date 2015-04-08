//
//  RKCountryDetailsViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 28/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKCountryDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Country.h"
#import "RKGWebView.h"

#import "RKGeonamesUtils.h"
#import "RKGeonamesConstants.h"

#import "RKGeonames-Swift.h"

NS_ENUM(NSInteger, ActiveMode_t) {
    ADMINISTRATION,
    DEMOGRAPHIC,
    ECONOMICS
};

@interface RKCountryDetailsViewController ()<UIWebViewDelegate, UIPickerViewDelegate, SideBarMenuDelegate>

@property (strong, nonatomic) SideBarMenu* sideBarMenu;
@property (nonatomic, strong) NSDictionary *currentData;

@property (weak, nonatomic) IBOutlet UITableView *adminTableView;
@property (weak, nonatomic) IBOutlet UITableView *ecoDemoTableView;
@property (nonatomic, strong) IBOutlet UIWebView *mapView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet RKCountryDetailsDataController *dataController;

@property (assign) NSUInteger zoomFactor;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender;


@property (nonatomic) NSUInteger activeMode;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation RKCountryDetailsViewController

static NSString* const LOADING = @"loading ...";

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: initWithNibName                                     |+|
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
        // Custom initialization
    }
    return self;
}

- (void)setupWebViewGestureRecognizers {
    
    //setup pinch and spread gesture recognizers to zoom in and out the google map
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.mapView addGestureRecognizer:pinch];
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
// |+|    RETURN VALUE:  N/A                                                 |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activeMode = ADMINISTRATION;
    
    self.view.backgroundColor = [UIColor colorWithRed:(.86f) green:(0.93f) blue:1 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
    
    self.sideBarMenu = [[SideBarMenu alloc] initWithSourceView:self.view menuItems:@[@"ADMINISTRATION", @"DEMOGRAPHICS", @"ECONOMICS"] menuImages:@[@"administration", @"population", @"economics"]];
    self.sideBarMenu.delegate = self;
    
    self.adminTableView.backgroundColor = [UIColor clearColor];
    self.adminTableView.alwaysBounceVertical = NO;

    self.ecoDemoTableView.backgroundColor = [UIColor clearColor];
    self.ecoDemoTableView.alwaysBounceVertical = NO;
    self.ecoDemoTableView.hidden = YES;
    
    [self.dataController setupPickerViewData:^{
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:2 inComponent:0 animated:YES];
    }];
    self.pickerView.hidden = YES;
    
    [self.dataController setCountryData:self.country];
    [self.dataController setAdministrationDataDefaults];
    [self.dataController getAdministrationData:^(NSError *error) {
        [self.adminTableView reloadData];
    }];
    
    [self setupMapView];
    
//    [self setupWebViewGestureRecognizers];
    
//    [self addBackButton];
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

- (void)setupControlsWithZoom:(BOOL)zoomIn {
//    self.buttonAdministration.hidden = !zoomIn;
//    self.buttonDemographics.hidden = !zoomIn;
//    self.buttonEconomics.hidden = !zoomIn;
}

- (void) displayDemographicData {
    
    [self setDemographicDataDefaults];
    
    [self getDemographicData];
}

- (void) setDemographicDataDefaults {
    
}

- (void)getDemographicData {
    
}

#pragma mark - UITableViewDelegate functions

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];

//    UIColor *textColor = [UIColor colorWithRed:.15 green:.25 blue:.15 alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    //configure the titles label
    cell.textLabel.textColor = textColor;
    cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
    
    NSArray *titles = [self.dataController countryDetails][@"titles"];
    cell.textLabel.text = titles[indexPath.row];
    
    //configure the values label
    cell.detailTextLabel.textColor = textColor;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    NSArray *values = [self.dataController countryDetails][@"values"];
    cell.detailTextLabel.text = values[indexPath.row];
    
    //deal with the activity indicator inside each cell
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)cell.accessoryView;
    if(YES == [values[indexPath.row] isEqualToString:LOADING]) {
        
        //if there's one already, nothing to do
        if (nil != activityIndicator) {
            return;
        }
        
        //no activity indicator, create and start one
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        
        cell.accessoryView = activityIndicator;
        [activityIndicator startAnimating];
    }
    else {
        
        //we have a value, stop the indicator and remove it
        [activityIndicator stopAnimating];
        
        cell.accessoryView = nil;
    }
    
    
}

#pragma mark - UIPickerView

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = [[self.dataController pickerData] objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.dataController setSelectedYear:[[self.dataController pickerData] objectAtIndex:row]];
    
    if(self.activeMode == DEMOGRAPHIC) {
        [self didSelectDemographicIndex];
    }
    else {
        if(self.activeMode == ECONOMICS) {
            [self didSelectEconomicsIndex];
        }
    }
}

#pragma mark - UIWebView

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
static NSString *MAP_VIEW_URL = @"http://maps.google.com/maps/api/staticmap?size=%ux%u&&sensor=false&path=weight:3|fillcolor:|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f|%.02f,%.02f&scale=2";
static const NSUInteger INDICATOR_WIDTH = 30;
static const NSUInteger INDICATOR_HEGHT = 30;
- (void) setupMapView {
    self.mapView.delegate = self;
//    self.mapView.rkgdelegate = self;
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
    
    self.zoomFactor = 7;
    
    self.mapView.scalesPageToFit = YES;
    [self.mapView loadRequest:[self mapURLRequest:CGSizeMake(570, 570)]];
    self.mapView.alpha = 1;
    
}

- (NSURLRequest *)mapURLRequest:(CGSize)dimensions {
    
    float lah = [self.country.north floatValue] + .5,
    lal = [self.country.south floatValue] - .5,
    loh = [self.country.east floatValue] + .5,
    lol = [self.country.west floatValue] - .5;
    
    static const NSUInteger ZOOMIN_WIDTH = 400;
    static const NSUInteger ZOOMIN_HEIGHT = 400;
    
    NSString *urlString = [NSString stringWithFormat:MAP_VIEW_URL, (NSUInteger)ZOOMIN_WIDTH, (NSUInteger)ZOOMIN_HEIGHT, lah, loh, lah, lol, lal, lol, lal, loh, lah, loh, self.zoomFactor];
    if(self.zoomFactor < 7) {
        
        NSString *mapViewURLFormat = [NSString stringWithFormat:@"%@%@", MAP_VIEW_URL, @"&zoom=%u"];
        
        urlString = [NSString stringWithFormat:mapViewURLFormat, (NSUInteger)ZOOMIN_WIDTH, (NSUInteger)ZOOMIN_HEIGHT, lah, loh, lah, lol, lal, lol, lal, loh, lah, loh, self.zoomFactor];
    }
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

#pragma mark - SideBarMenu delegates

- (void)didSelectItemAtIndex:(NSInteger)index {
    
    static const int DEMOGRAPHIC_INDEX = 1;
    static const int ECONOMICS_INDEX = 2;
    
    switch (index) {

        case DEMOGRAPHIC_INDEX:
            [self didSelectDemographicIndex];
            break;

        case ECONOMICS_INDEX:
            [self didSelectEconomicsIndex];
            break;
            
            
        default:
            [self didSelectAdministrationIndex];
            break;
    }
    
}

- (void)didSelectAdministrationIndex {
    
    self.activeMode = ADMINISTRATION;
    
    self.adminTableView.hidden = NO;
    self.ecoDemoTableView.hidden = YES;
    self.pickerView.hidden = YES;
    
    [self.dataController setAdministrationDataDefaults];
    [self.dataController getAdministrationData:^(NSError *error) {
        [self.adminTableView reloadData];
    }];
}

- (void)didSelectDemographicIndex {

    self.activeMode = DEMOGRAPHIC;
    
    self.adminTableView.hidden = YES;
    self.ecoDemoTableView.hidden = NO;
    self.pickerView.hidden = NO;
    
    [self.dataController setDemographicDataDefaults];
    [self.dataController getDemographicData:^(NSError *error) {
        [self.ecoDemoTableView reloadData];
    }];
}

- (void)didSelectEconomicsIndex {

    self.activeMode = ECONOMICS;
    
    self.adminTableView.hidden = YES;
    self.ecoDemoTableView.hidden = NO;
    self.pickerView.hidden = NO;
    
    [self.dataController setEconomicsDataDefaults];
    [self.dataController getEconomicsData:^(NSError *error) {
        
        [self.ecoDemoTableView reloadData];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*) otherRecognizer {
    return YES;
}

#pragma mark - IBActions

- (IBAction)menuButtonTapped:(id)sender {
    
    [self.sideBarMenu show:YES];
}

- (IBAction)backButtonTapped:(id)sender {
    
    [self.sideBarMenu hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    if([sender scale] < 1) {
        NSLog(@"zoom out");
        
        if(self.zoomFactor > 1) {
            --self.zoomFactor;
        }
        
        [self.mapView loadRequest:[self mapURLRequest:CGSizeMake(570, 570)]];
    }
    else {
        
        if(self.zoomFactor < 13) {
            ++self.zoomFactor;
        }
        
        [self.mapView loadRequest:[self mapURLRequest:CGSizeMake(570, 570)]];
        NSLog(@"zomm in");
    }
    
}
@end
