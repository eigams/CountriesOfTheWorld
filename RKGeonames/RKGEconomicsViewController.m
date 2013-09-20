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

@interface RKGEconomicsViewController ()
{
    NSString *Currency;
    NSString *GDP;
    NSString *GDPPerCapita;
    NSString *GNIPerCapita;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *currencies;

@end

@implementation RKGEconomicsViewController

@synthesize items;
@synthesize currencies;

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
- (NSDictionary *) currenciesD
{
    return [NSDictionary dictionaryWithObjectsAndKeys: @"United Arab Emirates Dirham", @"AED",
                                @"Afghanistan Afghani", @"AFN",
                                @"Albania Lek", @"ALL",  
                                @"Armenia Dram", @"AMD",	
                                @"Netherlands Antilles Guilder", @"ANG",	
                                @"Angola Kwanza", @"AOA",	
                                @"Argentina Peso", @"ARS",	
                                @"Australia Dollar",  @"AUD",	
                                @"Aruba Guilder", @"AWG",	
                                @"Azerbaijan New Manat", @"AZN",	
                                @"Bosnia and Herzegovina Convertible Marka", @"BAM",	
                                @"Barbados Dollar", @"BBD",	
                                @"Bangladesh Taka", @"BDT",	
                                @"Bulgaria Lev", @"BGN",	
                                @"Bahrain Dinar", @"BHD",	
                                @"Burundi Franc", @"BIF",	
                                @"Bermuda Dollar", @"BMD",	
                                @"Brunei Darussalam Dollar", @"BND",	
                                @"Bolivia Boliviano", @"BOB",	
                                @"Brazil Real", @"BRL",	
                                @"Bahamas Dollar",@"BSD",	
                                @"Bhutan Ngultrum",@"BTN",	
                                @"Botswana Pula",@"BWP",	
                                @"Belarus Ruble",@"BYR",	
                                @"Belize Dollar",@"BZD",	
                                @"Canada Dollar",@"CAD",	
                                @"Congo/Kinshasa Franc",@"CDF",	
                                @"Switzerland Franc",@"CHF",	
                                @"Chile Peso",@"CLP",	
                                @"China Yuan Renminbi",@"CNY",	
                                @"Colombia Peso",@"COP",	
                                @"Costa Rica Colon",@"CRC",	
                                @"Cuba Convertible Peso",@"CUC",	
                                @"Cuba Peso",@"CUP",	
                                @"Cape Verde Escudo",@"CVE",	
                                @"Czech Republic Koruna",@"CZK",	
                                @"Djibouti Franc",@"DJF",	
                                @"Denmark Krone",@"DKK",	
                                @"Dominican Republic Peso",@"DOP",	
                                @"Algeria Dinar",@"DZD",	
                                @"Egypt Pound",@"EGP",	
                                @"Eritrea Nakfa",@"ERN",	
                                @"Ethiopia Birr",@"ETB",	
                                @"Euro Member Countries",@"EUR",	
                                @"Fiji Dollar",@"FJD",	
                                @"Falkland Islands (Malvinas) Pound",@"FKP",	
                                @"United Kingdom Pound",@"GBP",	
                                @"Georgia Lari",@"GEL",	
                                @"Guernsey Pound",@"GGP",	
                                @"Ghana Cedi",@"GHS",	
                                @"Gibraltar Pound",@"GIP",	
                                @"Gambia Dalasi",@"GMD",	
                                @"Guinea Franc",@"GNF",	
                                @"Guatemala Quetzal",@"GTQ",	
                                @"Guyana Dollar",@"GYD",	
                                @"Hong Kong Dollar",@"HKD",	
                                @"Honduras Lempira",@"HNL",	
                                @"Croatia Kuna", @"HRK",	
                                @"Haiti Gourde",@"HTG",	
                                @"Hungary Forint",@"HUF",	
                                @"Indonesia Rupiah",@"IDR",	
                                @"Israel Shekel",@"ILS",	
                                @"Isle of Man Pound",@"IMP",	
                                @"India Rupee",@"INR",	
                                @"Iraq Dinar",@"IQD",	
                                @"Iran Rial",@"IRR",	
                                @"Iceland Krona",@"ISK",	
                                @"Jersey Pound",@"JEP",	
                                @"Jamaica Dollar",@"JMD",	
                                @"Jordan Dinar",@"JOD",	
                                @"Japan Yen",@"JPY",	
                                @"Kenya Shilling",@"KES",	
                                @"Kyrgyzstan Som",@"KGS",	
                                @"Cambodia Riel",@"KHR",	
                                @"Comoros Franc",@"KMF",	
                                @"Korea (North) Won",@"KPW",	
                                @"Korea (South) Won",@"KRW",	
                                @"Kuwait Dinar",@"KWD",	
                                @"Cayman Islands Dollar",@"KYD",	
                                @"Kazakhstan Tenge",@"KZT",	
                                @"Laos Kip",@"LAK",	
                                @"Lebanon Pound",@"LBP",	
                                @"Sri Lanka Rupee",@"LKR",	
                                @"Liberia Dollar",@"LRD",	
                                @"Lesotho Loti",@"LSL",	
                                @"Lithuania Litas",@"LTL",	
                                @"Latvia Lat",@"LVL",	
                                @"Libya Dinar",@"LYD",	
                                @"Morocco Dirham",@"MAD",	
                                @"Moldova Leu",@"MDL",	
                                @"Madagascar Ariary",@"MGA",	
                                @"Macedonia Denar",@"MKD",	
                                @"Myanmar (Burma) Kyat",@"MMK",	
                                @"Mongolia Tughrik",@"MNT",	
                                @"Macau Pataca",@"MOP",	
                                @"Mauritania Ouguiya",@"MRO",	
                                @"Mauritius Rupee",@"MUR",	
                                @"Maldives (Maldive Islands) Rufiyaa",@"MVR",	
                                @"Malawi Kwacha",@"MWK",	
                                @"Mexico Peso",@"MXN",	
                                @"Malaysia Ringgit",@"MYR",	
                                @"Mozambique Metical",@"MZN",	
                                @"Namibia Dollar",@"NAD",	
                                @"Nigeria Naira",@"NGN",	
                                @"Nicaragua Cordoba",@"NIO",	
                                @"Norway Krone",@"NOK",	
                                @"Nepal Rupee",@"NPR",	
                                @"New Zealand Dollar",@"NZD",	
                                @"Oman Rial",@"OMR",	
                                @"Panama Balboa",@"PAB",	
                                @"Peru Nuevo Sol",@"PEN",	
                                @"Papua New Guinea Kina",@"PGK",	
                                @"Philippines Peso",@"PHP",	
                                @"Pakistan Rupee",@"PKR",	
                                @"Poland Zloty",@"PLN",	
                                @"Paraguay Guarani",@"PYG",	
                                @"Qatar Riyal",@"QAR",	
                                @"Romania New Leu",@"RON",	
                                @"Serbia Dinar",@"RSD",	
                                @"Russia Ruble",@"RUB",	
                                @"Rwanda Franc",@"RWF",	
                                @"Saudi Arabia Riyal",@"SAR",	
                                @"Solomon Islands Dollar",@"SBD",	
                                @"Seychelles Rupee",@"SCR",	
                                @"Sudan Pound",@"SDG",	
                                @"Sweden Krona",@"SEK",	
                                @"Singapore Dollar",@"SGD",	
                                @"Saint Helena Pound",@"SHP",	
                                @"Sierra Leone Leone",@"SLL",	
                                @"Somalia Shilling",@"SOS",	
                                @"Seborga Luigino",@"SPL",	
                                @"Suriname Dollar",@"SRD",	
                                @"São Tomé and Príncipe Dobra",@"STD",	
                                @"El Salvador Colon",@"SVC",	
                                @"Syria Pound",@"SYP",	
                                @"Swaziland Lilangeni",@"SZL",	
                                @"Thailand Baht",@"THB",	
                                @"Tajikistan Somoni",@"TJS",	
                                @"Turkmenistan Manat",@"TMT",	
                                @"Tunisia Dinar",@"TND",	
                                @"Tonga Pa'anga",@"TOP",	
                                @"TRY",	@"Turkey Lira",
                                @"Trinidad and Tobago Dollar",@"TTD",	
                                @"Tuvalu Dollar",@"TVD",	
                                @"Taiwan New Dollar",@"TWD",	
                                @"Tanzania Shilling",@"TZS",	
                                @"Ukraine Hryvna",@"UAH",	
                                @"Uganda Shilling",@"UGX",	
                                @"United States Dollar",@"USD",	
                                @"Uruguay Peso",@"UYU",	
                                @"Uzbekistan Som",@"UZS",	
                                @"Venezuela Bolivar",@"VEF",	
                                @"Viet Nam Dong",@"VND",	
                                @"Vanuatu Vatu",@"VUV",	
                                @"Samoa Tala",@"WST",	
                                @"Communauté Financière Africaine (BEAC) CFA Franc BEAC",@"XAF",	
                                @"East Caribbean Dollar",@"XCD",	
                                @"International Monetary Fund (IMF) Special Drawing Rights",@"XDR",	
                                @"Communauté Financière Africaine (BCEAO) Franc",@"XOF",	
                                @"Comptoirs Français du Pacifique (CFP) Franc",@"XPF",	
                                @"Yemen Rial",@"YER",	
                                @"South Africa Rand",@"ZAR",	
                                @"Zambia Kwacha",@"ZMW",	
                                @"Zimbabwe Dollar", @"ZWD",	nil];
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
    EconomyData *economyData = [[EconomyData alloc] initWithCurrency:Currency
                                                                 gdp:GDP
                                                               gdppc:GDPPerCapita
                                                               gnipc:GNIPerCapita];
    
    currentData = [economyData tr_tableRepresentation];
    
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
- (void) getIndicatorData:(NSString *)indicator withHandler:(void (^)(NSString *Data))handler
{
    [RKGeonamesUtils fetchWorldBankIndicator:indicator
                              forCountryCode:self.country.countryCode
                                    withType:TYPE_FLOAT
                                     andText:[NSString stringWithFormat:@" %C", dollar]
                       withActivityIndicator:self.activityIndicator
                                 withHandler:handler];
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
static NSString *GDP_INDICATOR_STRING = @"NY.GDP.MKTP.CD";
static NSString *GDP_PER_CAPITA_INDICATOR_STRING = @"GDPPCKD";
static NSString *GNI_PER_CAPITA_INDICATOR_STRING = @"NY.GNP.PCAP.CD";
static UniChar dollar = 0x0024;
- (void) getData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self getIndicatorData:GDP_INDICATOR_STRING withHandler:^(NSString *Data){
            
            GDP = Data;
            
            [self loadData];
        }];

        [self getIndicatorData:GDP_PER_CAPITA_INDICATOR_STRING withHandler:^(NSString *Data){
            
            GDPPerCapita = Data;
            
            [self loadData];
        }];

        [self getIndicatorData:GNI_PER_CAPITA_INDICATOR_STRING withHandler:^(NSString *Data){
            
            GNIPerCapita = Data;
            
            [self loadData];
        }];

    });
    
    [self loadData];
}

static int TYPE_FLOAT = 1;
static int TYPE_INT = 2;

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
static NSString *NOT_AVAILABLE_TEXT = @"Not available";
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addHomeButton];
    
    self.currencies = [self currenciesD];
    Currency     = [self.currencies valueForKey:self.country.currency];
    GDP          = NOT_AVAILABLE_TEXT;
    GDPPerCapita = NOT_AVAILABLE_TEXT;
    GNIPerCapita = NOT_AVAILABLE_TEXT;
    
    [self.view addSubview:self.activityIndicator];
    
    [self getData];
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

@end
