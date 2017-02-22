//
//  ConfigurationController.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Weather.h"
#import "City.h"

@interface ConfigurationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
//@property (nonatomic, strong) City *userCity;
//@property (nonatomic, strong) Weather *userWeather;
@property (nonatomic, strong) NSMutableDictionary *settingsDict;

- (void)saveChangesOnConfigurationDict;

- (BOOL)isHumidityShown;
- (BOOL)isPressureShown;
- (BOOL)isWindSpeedShown;

+ (instancetype)sharedInstance;

@end
