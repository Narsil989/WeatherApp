//
//  ConfigurationController.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "ConfigurationManager.h"

#define kConfigFileName @"Configuration"

@implementation ConfigurationManager
#pragma mark -
#pragma mark Lifecycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static ConfigurationManager *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [ConfigurationManager new];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self setupLocationManager];
    [self loadSettingsDictionary];
    
}

- (void)setupLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
        [self.locationManager requestWhenInUseAuthorization];
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAcceptedLocation" object:nil];
        [_locationManager startUpdatingLocation];
    }
}

- (void)loadSettingsDictionary
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self configFilePath]] && [[NSFileManager defaultManager] fileExistsAtPath:[self bundledConfigFilePath]])
    {
        self.settingsDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self bundledConfigFilePath]];
        [self.settingsDict writeToFile:[self configFilePath] atomically:YES];
        
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:[self configFilePath]])
    {
        self.settingsDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self configFilePath]];
    }
    
}



#pragma mark - Config file

- (NSString *)bundledConfigFilePath
{
    return [[NSBundle mainBundle] pathForResource:kConfigFileName ofType:@"plist"];
}

- (NSString *)configFilePath
{
    return [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"Configuration.plist"];
}

- (void)saveChangesOnConfigurationDict
{
    [self.settingsDict writeToFile:[self configFilePath] atomically:YES];
}

#pragma mark - Location manager Delegate

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusDenied:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDeclinedLocation" object:nil];
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [_locationManager startUpdatingLocation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAcceptedLocation" object:nil];
        }
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentUserLocation = [locations objectAtIndex:0];
    
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:_currentUserLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLocationUpdated" object:nil userInfo:@{@"cityName" : placemark.locality,
                                                                                                                     @"longitude" : [NSString stringWithFormat:@"%.6f",  _currentUserLocation.coordinate.longitude],
                                                                                                                     @"latitude" : [NSString stringWithFormat:@"%.6f",  _currentUserLocation.coordinate.latitude]
                                                                                                                     }];
         }
     }];
}


@end
