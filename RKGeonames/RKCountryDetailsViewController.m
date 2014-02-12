//
//  RKCountryDetailsViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 28/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKCountryDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RKGAdministrationViewController.h"


@interface RKCountryDetailsViewController ()

@end

@implementation RKCountryDetailsViewController

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

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: addBackButton                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   add a "Back" button to the navigation bar           |+|
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
- (void) addBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: buttonAddBorder                                     |+|
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
- (void) buttonAddBorder:(UIButton *)button
{
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.cornerRadius = 8;
    button.layer.masksToBounds = YES;
}

- (void)performSegue:(NSString *)identifier
{
    [self performSegueWithIdentifier:identifier sender:self];
}

static NSString * const AdministrationSegue = @"AdministrationSegue";
static NSString * const DemographicsSegue = @"DemographicsSegue";
static NSString * const EconomicsSegue = @"EconomicsSegue";

- (void)pushAdminViewController
{
    [self performSegue:AdministrationSegue];
}

- (void)pushDemographicsViewController
{
    [self performSegue:DemographicsSegue];
}

- (void)pushEconomicsViewController
{
    [self performSegue:EconomicsSegue];
}

- (UIButton *)createButton:(SEL)action
                   withTitle:(NSString *)title
                   withFrame:(CGRect)frame
                 withBgImage:(UIImage *)bgin
                 withBgImageH:(UIImage *)bginh
                 withFont:(UIFont *)font
                 withColor:(UIColor *)color
                 withColorH:(UIColor *)colorh
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    [btn setFrame:frame];
    [btn setBackgroundImage:bgin forState:UIControlStateNormal];
    [btn setBackgroundImage:bginh forState:UIControlStateHighlighted];
    
    NSDictionary *attrDictn = @{NSFontAttributeName : [UIFont fontWithName:@"OriyaSangamMN-Bold" size:24],
                               NSForegroundColorAttributeName : [UIColor colorWithRed:0.0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0]};
    NSDictionary *attrDicth = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                               NSForegroundColorAttributeName : [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1.0]};
    
    NSMutableAttributedString *titlen = [[NSMutableAttributedString alloc] initWithString:title attributes: attrDictn];
    NSMutableAttributedString *titleh = [[NSMutableAttributedString alloc] initWithString:title attributes: attrDicth];
    
    [titlen addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titlen length])];
    [titleh addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleh length])];
    
    [btn setAttributedTitle:titlen forState:UIControlStateNormal];
    [btn setAttributedTitle:titleh forState:UIControlStateHighlighted];
    
    return btn;
}

- (NSValue *)selectorAsValue:(SEL)selector
{
    return [NSValue valueWithBytes:&selector objCType:@encode(SEL)];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: createButtons                                       |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:                                                       |+|
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
static NSString * const BUTTON_IMAGE = @"Button.png";
static NSString * const BUTTONHL_IMAGE = @"ButtonHighlighted.png";
static NSString * const BUTTON_TEXT_ABOUT = @"About";
static NSString * const BUTTON_TEXT_DEMOGR = @"Demographics";
static NSString * const BUTTON_TEXT_ECONOMICS = @"Economics";
- (void)createButtons
{
    UIFont *buttonFont = [UIFont fontWithName:@"Nitti Typewriter Underlined" size:28.0];
    UIColor *buttonColorDefault = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    UIImage *btn = [UIImage imageNamed:BUTTON_IMAGE];
    UIImage *btnh = [UIImage imageNamed:BUTTONHL_IMAGE];
    
    NSArray *params = @[@[[self selectorAsValue:@selector(pushAdminViewController)],        BUTTON_TEXT_ABOUT,      [NSValue valueWithCGRect:self.buttonAdministration.frame]],
                        @[[self selectorAsValue:@selector(pushDemographicsViewController)], BUTTON_TEXT_DEMOGR,     [NSValue valueWithCGRect:self.buttonDemographics.frame]],
                        @[[self selectorAsValue:@selector(pushEconomicsViewController)],    BUTTON_TEXT_ECONOMICS,  [NSValue valueWithCGRect:self.buttonEconomics.frame]]];
    
    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SEL selector;
        [[obj objectAtIndex:0] getValue:&selector];
        
        if (nil == selector) {
            *stop = YES;
            
            return;
        }
        
        UIButton *button = [self createButton:selector
                                  withTitle:[obj objectAtIndex:1]
                                  withFrame:[[obj objectAtIndex:2] CGRectValue]
                                withBgImage:btn
                               withBgImageH:btnh
                                   withFont:buttonFont
                                  withColor:buttonColorDefault
                                 withColorH:buttonColorHighlight];
        
        [self.view addSubview:button];

    }];
    
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
    
    [self createButtons];
    
    self.buttonAdministration.hidden = YES;
    self.buttonEconomics.hidden = YES;
    self.buttonDemographics.hidden = YES;
    
    [self buttonAddBorder:self.buttonAdministration];
    [self buttonAddBorder:self.buttonEconomics];
    [self buttonAddBorder:self.buttonDemographics];
    
    [self addBackButton];
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

@end
