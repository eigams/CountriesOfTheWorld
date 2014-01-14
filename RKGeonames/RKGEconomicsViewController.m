//
//  RKGEconomicsViewController.m
//  RKGeonames
//
//  Created by Stefan Burettea on 30/06/2013.
//  Copyright (c) 2013 Stefan Burettea. All rights reserved.
//

#import "RKGEconomicsViewController.h"

#import "MappingProvider.h"
#import "WorldBankIndicator.h"
#import "RKGeonamesUtils.h"
#import "EconomyData+TableRepresentation.h"

#import "RKGeonamesConstants.h"

@interface RKGEconomicsViewController ()
{
    NSString *Currency;
    NSString *GDP;
    NSString *GDPPerCapita;
    NSString *GNIPerCapita;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong, readonly) NSDictionary *currencies;

@property (nonatomic, strong) IBOutlet UITextField *year;

@end

@implementation RKGEconomicsViewController

@synthesize items;
//@synthesize currencies;

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: currenciesD                                         |+|
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
- (NSDictionary *) currencies
{
    static NSDictionary *currency = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        currency = @{@"AED": @"United Arab Emirates Dirham",
                     @"AFN": @"Afghanistan Afghani",
                     @"ALL": @"Albania Lek",
                     @"AMD": @"Armenia Dram",
                     @"ANG": @"Netherlands Antilles Guilder",
                     @"AOA": @"Angola Kwanza",
                     @"ARS": @"Argentina Peso",
                     @"AUD": @"Australia Dollar",
                     @"AWG": @"Aruba Guilder",
                     @"AZN": @"Azerbaijan New Manat",
                     @"BAM": @"Bosnia and Herzegovina Convertible Marka",
                     @"BBD": @"Barbados Dollar",
                     @"BDT": @"Bangladesh Taka",
                     @"BGN": @"Bulgaria Lev",
                     @"BHD": @"Bahrain Dinar",
                     @"BIF": @"Burundi Franc",
                     @"BMD": @"Bermuda Dollar",
                     @"BND": @"Brunei Darussalam Dollar",
                     @"BOB": @"Bolivia Boliviano",
                     @"BRL": @"Brazil Real",
                     @"BSD": @"Bahamas Dollar",
                     @"BTN": @"Bhutan Ngultrum",
                     @"BWP": @"Botswana Pula",
                     @"BYR": @"Belarus Ruble",
                     @"BZD": @"Belize Dollar",
                     @"CAD": @"Canada Dollar",
                     @"CDF": @"Congo/Kinshasa Franc",
                     @"CHF": @"Switzerland Franc",
                     @"CLP": @"Chile Peso",
                    @"CNY": @"China Yuan Renminbi",
                    @"COP": @"Colombia Peso",
                    @"CRC": @"Costa Rica Colon",
                    @"CUC": @"Cuba Convertible Peso",
                    @"CUP": @"Cuba Peso",
                    @"CVE": @"Cape Verde Escudo",
                    @"CZK": @"Czech Republic Koruna",
                    @"DJF": @"Djibouti Franc",
                    @"DKK": @"Denmark Krone",
                    @"DOP": @"Dominican Republic Peso",
                    @"DZD": @"Algeria Dinar",
                    @"EGP": @"Egypt Pound",
                    @"ERN": @"Eritrea Nakfa",
                    @"ETB": @"Ethiopia Birr",
                    @"EUR": @"Euro Member Countries",
                    @"FJD": @"Fiji Dollar",
                    @"FKP": @"Falkland Islands (Malvinas) Pound",
                    @"GBP": @"United Kingdom Pound",
                    @"GEL": @"Georgia Lari",
                    @"GGP": @"Guernsey Pound",
                    @"GHS": @"Ghana Cedi",
                    @"GIP": @"Gibraltar Pound",
                    @"GMD": @"Gambia Dalasi",
                    @"GNF": @"Guinea Franc",
                    @"GTQ": @"Guatemala Quetzal",
                    @"GYD": @"Guyana Dollar",
                    @"HKD": @"Hong Kong Dollar",
                    @"HNL": @"Honduras Lempira",
                    @"HRK": @"Croatia Kuna",
                    @"HTG": @"Haiti Gourde",
                    @"HUF": @"Hungary Forint",
                    @"IDR": @"Indonesia Rupiah",
                    @"ILS": @"Israel Shekel",
                    @"IMP": @"Isle of Man Pound",
                    @"INR": @"India Rupee",
                    @"IQD": @"Iraq Dinar",
                    @"IRR": @"Iran Rial",
                    @"ISK": @"Iceland Krona",
                    @"JEP": @"Jersey Pound",
                    @"JMD": @"Jamaica Dollar",
                    @"JOD": @"Jordan Dinar",
                    @"JPY": @"Japan Yen",
                    @"KES": @"Kenya Shilling",
                    @"KGS": @"Kyrgyzstan Som",
                    @"KHR": @"Cambodia Riel",
                    @"KMF": @"Comoros Franc",
                    @"KPW": @"Korea (North) Won",
                    @"KRW": @"Korea (South) Won",
                    @"KWD": @"Kuwait Dinar",
                    @"KYD": @"Cayman Islands Dollar",
                    @"KZT": @"Kazakhstan Tenge",
                    @"LAK": @"Laos Kip",
                    @"LBP": @"Lebanon Pound",
                    @"LKR": @"Sri Lanka Rupee",
                    @"LRD": @"Liberia Dollar",
                    @"LSL": @"Lesotho Loti",
                    @"LTL": @"Lithuania Litas",
                    @"LVL": @"Latvia Lat",
                    @"LYD": @"Libya Dinar",
                    @"MAD": @"Morocco Dirham",
                    @"MDL": @"Moldova Leu",
                    @"MGA": @"Madagascar Ariary",
                    @"MKD": @"Macedonia Denar",
                    @"MMK": @"Myanmar (Burma) Kyat",
                    @"MNT": @"Mongolia Tughrik",
                    @"MOP": @"Macau Pataca",
                    @"MRO": @"Mauritania Ouguiya",
                    @"MUR": @"Mauritius Rupee",
                    @"MVR": @"Maldives (Maldive Islands) Rufiyaa",
                    @"MWK": @"Malawi Kwacha",
                    @"MXN": @"Mexico Peso",
                    @"MYR": @"Malaysia Ringgit",
                    @"MZN": @"Mozambique Metical",
                    @"NAD": @"Namibia Dollar",
                    @"NGN": @"Nigeria Naira",
                    @"NIO": @"Nicaragua Cordoba",
                    @"NOK": @"Norway Krone",
                    @"NPR": @"Nepal Rupee",
                    @"NZD": @"New Zealand Dollar",
                    @"OMR": @"Oman Rial",
                    @"PAB": @"Panama Balboa",
                    @"PEN": @"Peru Nuevo Sol",
                    @"PGK": @"Papua New Guinea Kina",
                    @"PHP": @"Philippines Peso",
                    @"PKR": @"Pakistan Rupee",
                    @"PLN": @"Poland Zloty",
                    @"PYG": @"Paraguay Guarani",
                    @"QAR": @"Qatar Riyal",
                    @"RON": @"Romania New Leu",
                    @"RSD": @"Serbia Dinar",
                    @"RUB": @"Russia Ruble",
                    @"RWF": @"Rwanda Franc",
                    @"SAR": @"Saudi Arabia Riyal",
                    @"SBD": @"Solomon Islands Dollar",
                    @"SCR": @"Seychelles Rupee",
                    @"SDG": @"Sudan Pound",
                    @"SEK": @"Sweden Krona",
                    @"SGD": @"Singapore Dollar",
                    @"SHP": @"Saint Helena Pound",
                    @"SLL": @"Sierra Leone Leone",
                    @"SOS": @"Somalia Shilling",
                    @"SPL": @"Seborga Luigino",
                    @"SRD": @"Suriname Dollar",
                    @"STD": @"São Tomé and Príncipe Dobra",
                    @"SVC": @"El Salvador Colon",
                    @"SYP": @"Syria Pound",
                    @"SZL": @"Swaziland Lilangeni",
                    @"THB": @"Thailand Baht",
                    @"TJS": @"Tajikistan Somoni",
                    @"TMT": @"Turkmenistan Manat",
                    @"TND": @"Tunisia Dinar",
                    @"TOP": @"Tonga Pa'anga",
                    @"TRY": @"Turkey Lira",
                    @"TTD": @"Trinidad and Tobago Dollar",
                    @"TVD": @"Tuvalu Dollar",
                    @"TWD": @"Taiwan New Dollar",
                    @"TZS": @"Tanzania Shilling",
                    @"UAH": @"Ukraine Hryvna",
                    @"UGX": @"Uganda Shilling",
                    @"USD": @"United States Dollar",
                    @"UYU": @"Uruguay Peso",
                    @"UZS": @"Uzbekistan Som",
                    @"VEF": @"Venezuela Bolivar",
                    @"VND": @"Viet Nam Dong",
                    @"VUV": @"Vanuatu Vatu",
                    @"WST": @"Samoa Tala",
                    @"XAF": @"Communauté Financière Africaine (BEAC) CFA Franc BEAC",
                    @"XCD": @"East Caribbean Dollar",
                    @"XDR": @"International Monetary Fund (IMF) Special Drawing Rights",
                    @"XOF": @"Communauté Financière Africaine (BCEAO) Franc",
                    @"XPF": @"Comptoirs Français du Pacifique (CFP) Franc",
                    @"YER": @"Yemen Rial",
                    @"ZAR": @"South Africa Rand",
                    @"ZMW": @"Zambia Kwacha",
                    @"ZWD": @"Zimbabwe Dollar"};
    });
    
    return currency;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
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
// |+|                                                                       |+|
// |+|    FUNCTION NAME: loadData                                            |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:  once the data is collected, it needs to be formatted |+|
// |+|                  and the uitableview updated                          |+|
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
- (BOOL)loadData
{
    @try {
        EconomyData *economyData = [[EconomyData alloc] initWithCurrency:(Currency == nil) ? @"N/A" : Currency
                                                                     gdp:(GDP == nil) ? @"N/A" : GDP
                                                                   gdppc:(GDPPerCapita == nil) ? @"N/A" : GDPPerCapita
                                                                   gnipc:(GNIPerCapita == nil) ? @"N/A" : GNIPerCapita];
        
        NSLog(@"before currentData creation");
        currentData = [economyData tr_tableRepresentation];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception caught in loadData: %@", exception);
    }
    
    NSLog(@"before reload");
    
    [self.tableView reloadData];
    
    return YES;
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: getIndicatorData                                    |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION: overload of 'fetchWorldBankIndicator' function        |+|
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
- (void) getIndicatorData:(NSString *)indicator withCompletion:(void (^)(NSString *Data))completion
{
    [RKGeonamesUtils fetchWorldBankIndicator:indicator
                              forCountryCode:self.country.countryCode
                                     forYear:(self.year.text == nil) ? @"2011" : self.year.text
                                    withType:TYPE_FLOAT
                                     andText:[NSString stringWithFormat:@" %C", dollar]
                                 withCompletion:completion
                                    failure:^{
                                        currentData = [[EconomyData data] tr_tableRepresentation];
                                        
                                        [self.tableView reloadData];
                                    }];
}

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: getData                                             |+|
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
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
static NSString * const GDP_INDICATOR_STRING = @"NY.GDP.MKTP.CD";
static NSString * const GDP_PER_CAPITA_INDICATOR_STRING = @"NY.GDP.PCAP.CD";//@"GDPPCKD";
static NSString * const GNI_PER_CAPITA_INDICATOR_STRING = @"NY.GNP.PCAP.CD";
static UniChar dollar = 0x0024;
- (void) getData
{
    @try {
        
        NSLog(@"before currentData created !");
        
        currentData = [[EconomyData data] tr_tableRepresentation];
        
        GDP          = LOADING_STRING;
        GDPPerCapita = LOADING_STRING;
        GNIPerCapita = LOADING_STRING;

        [self.tableView reloadData];
        
        NSDictionary *bankIndicatorOutData = @{GDP_INDICATOR_STRING: @"GDP",
                                               GDP_PER_CAPITA_INDICATOR_STRING: @"GDPPerCapita",
                                               GNI_PER_CAPITA_INDICATOR_STRING: @"GNIPerCapita"};
        
        NSLog(@"currentData created !");
        
        [bankIndicatorOutData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            [self getIndicatorData:key withCompletion:^(NSString *Data){
                
                //KVC
                [self setValue:Data forKey:obj];
                
                [self loadData];
            }];
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Eception caught: %@", exception);
    }
}

static int TYPE_FLOAT = 1;

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
	// Do any additional setup after loading the view.
    
    self.year.delegate = self;
    [self.year setText:@"2011"];
    self.year.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self addBarButtons:@selector(getData)];
    
    //self.currencies = [self currenciesD];
    Currency     = [self.currencies valueForKey:self.country.currency];
    GDP          = LOADING_STRING;
    GDPPerCapita = LOADING_STRING;
    GNIPerCapita = LOADING_STRING;
    
    [self getData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: didReceiveMemoryWarning                             |+|
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
// |+|    RETURN VALUE:                                                      |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|=======================================================================|+|
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegates

// |+|=======================================================================|+|
// |+|                                                                       |+|
// |+|    FUNCTION NAME: textFieldShouldEndEditing                           |+|
// |+|                                                                       |+|
// |+|                                                                       |+|
// |+|    DESCRIPTION:   get the newly set year and refresh                  |+|
// |+|                   the collected data                                  |+|
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.year.text = textField.text;
    
    [self getData];
    
    return YES;
}


@end
