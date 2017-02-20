//
//  ForecastViewController.h
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "Weather.h"

@interface ForecastViewController : UIViewController


@property (nonatomic, strong) City *currentCity;
@property (nonatomic, strong) Weather *currentWeather;

@end
