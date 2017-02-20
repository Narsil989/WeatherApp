//
//  Weather.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSNumber *apparentTemperature;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSNumber *minTemperature;
@property (nonatomic, strong) NSNumber *mainTemperature;
@property (nonatomic, strong) NSNumber *maxTemperature;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) UIColor *backgroudColor;


@end
