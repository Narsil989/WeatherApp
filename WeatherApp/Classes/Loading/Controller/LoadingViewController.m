//
//  LoadingViewController.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 18/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "LoadingViewController.h"
#import "ForecastDataSource.h"
#import "City.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController
{
    ForecastDataSource *_forecastDS;
    CityEntity *_currentCity;
    NSDictionary *_userCityDataDict;
    NSManagedObjectContext *_mainManagedObjectContext;
    __weak IBOutlet UIButton *_refreshButton;
    
    BOOL alertShown;
    BOOL dataIsLoading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainManagedObjectContext = [[CoreDataManager sharedManager] mainManagedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertViewController:) name:@"UserLocationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startingData) name:@"UserDeclinedLocation" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertViewController:) name:@"UserAcceptedLocation" object:nil];

    _refreshButton.hidden = [[AFNetworkReachabilityManager sharedManager] isReachable];
    ConfigManager;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AppWasAlreadyUsed"])
        [self createFirstTimeRunData];
    
    if (!_forecastDS) _forecastDS = [ForecastDataSource new];
    [_forecastDS setMaxRows:@"10"];
    [_forecastDS setUsername:@"narsil"];
    [_forecastDS setDarkSkyToken:@"c445625667ffb6939409211d3255ff87"];
}

- (void)startingData
{

        [self loadLocalData];
}

- (void)loadUserData
{
    if (!dataIsLoading)
        dataIsLoading = YES;
    else
        return;
    
    __weak typeof(self)weakSelf = self;
    
    [LoadingView showLoadingViewInView:self.view WithCompletionBlock:^{
        
        //[weakSelf loadCurretCityData];
        
    }];
}

- (void)loadLocalData
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AppWasAlreadyUsed"])
        [self createFirstTimeRunData];
    
    NSArray *citiesArray = [[CoreDataManager sharedManager] citiesForSearchQuery:@"isSelected == YES"];
    
    if ([citiesArray count] == 0 && [[CoreDataManager sharedManager] citiesForSearchQuery:@""])
    {
        CityEntity *tmpCity = [[[CoreDataManager sharedManager] citiesForSearchQuery:@""] firstObject];
        [tmpCity setValue:@YES forKey:@"isSelected"];
    }
}

- (void)loadCurretCityData:(NSDictionary *)cityData
{
    __weak typeof(self)weakSelf = self;
    
    [_forecastDS getUserCityWithData:cityData andCompletionBlock:^(BOOL success, NSError *err, NSArray *itemsArray) {
        
        if (!err && success)
        {
            _currentCity = [itemsArray firstObject];
            [weakSelf selectUserCityAndDeselctOthers];
            [weakSelf loadWeather];
        }
        else
        {
            [LoadingView hideLoadingViewForView:self.view WithCompletionBlock:^{
               
                if (weakSelf.loadDataFinished)
                    weakSelf.loadDataFinished();
                
            }];
        }
        
    }];
    
    /*[_forecastDS getUserCityWithcompletionBlock:^(BOOL isDone, NSError *err, NSArray *arr)
     {
        _currentCity = [arr firstObject];
        [weakSelf loadWeather];
        
    }];*/
}

- (void)selectUserCityAndDeselctOthers
{
    for (CityEntity *entity in [[CoreDataManager sharedManager] citiesForSearchQuery:@""])
    {
        [entity setValue:@NO forKey:@"isSelected"];
    }
    
    [_currentCity setValue:@YES forKey:@"isSelected"];
}

/*- (void)addUserCityToLocalDataAndLoadWeather:(City *)city
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CityEntity class])
                                              inManagedObjectContext:[[CoreDataManager sharedManager] mainManagedObjectContext]];
    
    CityEntity *userCity = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:[[CoreDataManager sharedManager] mainManagedObjectContext]];
    //add osijek
    userCity.name = city.name;
    userCity.countryCode = city.countryCode;
    userCity.geonameId = [city.geonameId floatValue];
    userCity.isSelected = YES;
    userCity.longitude = city.longitude;
    userCity.latitude = city.latitude;
    
    [[CoreDataManager sharedManager].mainManagedObjectContext save:nil];
}*/

- (void)loadWeather
{
    __weak typeof(self)weakSelf = self;
    [_forecastDS getWeatherWithLongitude:_currentCity.longitude andLatitude:_currentCity.latitude WithcompletionBlock:^(BOOL isDone, NSError *err, NSArray *arr) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        ConfigManager.userWeather = [arr firstObject];
        
        [LoadingView hideLoadingViewForView:weakSelf.view WithCompletionBlock:^{
            
        if (strongSelf.loadDataFinished)
            strongSelf.loadDataFinished();
            
        }];
        
    }];
    
}

#pragma mark - Create first time run data

- (void)createFirstTimeRunData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CityEntity class])
                                              inManagedObjectContext:_mainManagedObjectContext];
    
    CityEntity *itemOsijek = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:_mainManagedObjectContext];
    CityEntity *itemTokyo = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:_mainManagedObjectContext];
    CityEntity *itemLondon = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:_mainManagedObjectContext];
    
    //add osijek
    itemOsijek.name = @"Osijek";
    itemOsijek.countryCode = @"HR";
    itemOsijek.geonameId = 3193935;
    itemOsijek.isSelected = NO;
    itemOsijek.longitude = @"18.69389";
    itemOsijek.latitude = @"45.55111";
    
    itemTokyo.name = @"Tokyo";
    itemTokyo.countryCode = @"JP";
    itemTokyo.geonameId = 1850147;
    itemTokyo.isSelected = NO;
    itemTokyo.latitude = @"35.6895";
    itemTokyo.longitude = @"139.69171";
    
    itemLondon.name = @"London";
    itemLondon.countryCode = @"GB";
    itemLondon.geonameId = 2643743;
    itemLondon.isSelected = NO;
    itemLondon.longitude = @"-0.12574";
    itemLondon.latitude = @"51.50853";
    
    [_mainManagedObjectContext save:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppWasAlreadyUsed"];
    
}

- (void)showAlertViewController:(NSNotification *)notif
{
    NSDictionary *dict =  notif.userInfo;
    if (alertShown || ![dict allKeys]) return;
    
    _userCityDataDict = dict;
    
    UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"Hello!"
                                                                         message:@"Would You like the app to use Your location for forecast?"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self)weakSelf = self;
    
    UIAlertAction *acceptanceAction = [UIAlertAction actionWithTitle:@"YES!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [LoadingView showLoadingViewInView:self.view WithCompletionBlock:^{
            
            [weakSelf loadCurretCityData:_userCityDataDict];
        }];
        
        alertShown = NO;
        
    }];
    
    UIAlertAction *declineAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        alertShown = NO;
    }];
    
    [chooseAlert addAction:acceptanceAction];
    [chooseAlert addAction:declineAction];
    
    [self presentViewController:chooseAlert animated:YES completion:nil];
}

- (IBAction)refreshButtonTapped:(id)sender
{
    [self loadCurretCityData:_userCityDataDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
