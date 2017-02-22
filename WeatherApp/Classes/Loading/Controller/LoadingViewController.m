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
    __weak IBOutlet UILabel *_noInternetLabel;
    ForecastDataSource *_forecastDS;
    CityEntity *_currentCity;
    NSDictionary *_userCityDataDict;
    NSManagedObjectContext *_mainManagedObjectContext;
    BOOL alertShown;
    BOOL dataIsLoading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainManagedObjectContext = [DataManager mainManagedObjectContext];
    
    _noInternetLabel.text = @"No internet connection, please check Your internet settings.";
    [WAStyle applyStyle:@"Settings_Title_Label" toLabel:_noInternetLabel];
    
    ConfigManager;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AppWasAlreadyUsed"])
    {
        [self createFirstTimeRunData];
    }
    
    if (!_forecastDS) _forecastDS = [ForecastDataSource new];
    [_forecastDS setMaxRows:@"10"];
    [_forecastDS setUsername:@"narsil"];
    [_forecastDS setDarkSkyToken:@"c445625667ffb6939409211d3255ff87"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAcceptedUsingLocation) name:@"UserAcceptedLocation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeclinedUsingLocation) name:@"UserDeclinedLocation" object:nil];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            _noInternetLabel.hidden = YES;
            [ConfigManager.locationManager startUpdatingLocation];
        }
        else
        {
            _noInternetLabel.hidden = NO;
        }
    }];
}

#pragma  mark - Location updates

- (void)userAcceptedUsingLocation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationUpdated:) name:@"UserLocationUpdated" object:nil];
}

- (void)userDeclinedUsingLocation
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserAlreadyAcceptedUsingLocation"];
    [self loadLocalData];
}

- (void)userLocationUpdated:(NSNotification *)notif
{
    if ([notif.userInfo allKeys])
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"UserAlreadyAcceptedUsingLocation"])
        {
            if (!alertShown)
                [self showAlertViewController:notif];
        }
        else
        {
            
            
            [self loadCurretCityData:notif.userInfo];
        }
    }
}

#pragma mark - Load data

- (void)loadLocalData
{
    NSArray *citiesArray = [DataManager citiesForSearchQuery:@"isSelected == YES"];
    
    if ([citiesArray count] == 0 && [DataManager citiesForSearchQuery:@""]) //check if there is already selected city
    {
        CityEntity *tmpCity = [[DataManager citiesForSearchQuery:@""] firstObject];
        [tmpCity setValue:@YES forKey:@"isSelected"];
        _currentCity = tmpCity;
    }
    else
        _currentCity = [citiesArray firstObject];
    
    __weak typeof(self)weakSelf = self;
    
    __weak typeof(_forecastDS)wForecastDS = _forecastDS;
    
    [LoadingView showLoadingViewInView:self.view WithCompletionBlock:^{
        
        if (!_currentCity)//still no selected city... get default one
        {
            [wForecastDS getDefaultCityWithcompletionBlock:^(BOOL done, NSError *err, NSArray *arr) {
                
                _currentCity = [arr firstObject];
                [DataManager setMainCitySelectAndDeselctOther:_currentCity];
                
                [LoadingView hideLoadingViewForView:self.view WithCompletionBlock:^{
                    
                    if (weakSelf.loadDataFinished)
                        weakSelf.loadDataFinished();
                    
                }];
            }];
        }
        else
            [LoadingView hideLoadingViewForView:self.view WithCompletionBlock:^{
                if (weakSelf.loadDataFinished)
                    weakSelf.loadDataFinished();
                
            }];
    }];
    
}

- (void)loadCurretCityData:(NSDictionary *)cityData
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(_forecastDS)wForecastDS = _forecastDS;
    [LoadingView showLoadingViewInView:self.view WithCompletionBlock:^{
        
        [wForecastDS getUserCityWithData:cityData andCompletionBlock:^(BOOL success, NSError *err, NSArray *itemsArray) {
            
            if (!err && success)
            {
                _currentCity = [itemsArray firstObject];
                [weakSelf selectUserCityAndDeselctOthers];
                [LoadingView hideLoadingViewForView:self.view WithCompletionBlock:^{
                    if (weakSelf.loadDataFinished)
                        weakSelf.loadDataFinished();
                    
                }];
            }
            else
            {
                [LoadingView hideLoadingViewForView:self.view WithCompletionBlock:^{
                    
                    if (weakSelf.loadDataFinished)
                        weakSelf.loadDataFinished();
                    
                }];
            }
            
        }];
    }];
}

- (void)selectUserCityAndDeselctOthers
{
    [DataManager setMainCitySelectAndDeselctOther:_currentCity];
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

#pragma mark - Helpers

- (void)showAlertViewController:(NSNotification *)notif
{
    NSDictionary *dict =  notif.userInfo;
    if (alertShown || ![dict allKeys])
        return;
    
    _userCityDataDict = dict;
    
    UIAlertController *chooseAlert = [UIAlertController alertControllerWithTitle:@"Hello!"
                                                                         message:@"Would You like the app to use Your location for forecast?"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self)weakSelf = self;
    
    UIAlertAction *acceptanceAction = [UIAlertAction actionWithTitle:@"YES!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf loadCurretCityData:_userCityDataDict];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserAlreadyAcceptedUsingLocation"];
        alertShown = NO;
        
    }];
    
    UIAlertAction *declineAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        alertShown = NO;
        [weakSelf loadLocalData];
    }];
    
    [chooseAlert addAction:acceptanceAction];
    [chooseAlert addAction:declineAction];
    
    [self presentViewController:chooseAlert animated:YES completion:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_forecastDS.manager.operationQueue cancelAllOperations];
    _forecastDS = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
