//
//  WeatherParser.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "WeatherParser.h"
#import "Weather.h"

@implementation WeatherParser

- (void)bindObject
{
    Weather *item = [Weather new];
    
    NSNumber *currentTime = [NSNumber new];
    
    if ([_currentElement objectForKey:@"currently"])
    {
        NSDictionary *currentWeather = [_currentElement objectForKey:@"currently"];
        item.apparentTemperature = [currentWeather valueForKey:@"apparentTemperature"];
        item.humidity = [currentWeather valueForKey:@"humidity"];
        item.icon = [currentWeather valueForKey:@"icon"];
        item.backgroudColor = [UIColor getColorFromIconString:[currentWeather valueForKey:@"icon"]];
        item.mainTemperature = [currentWeather valueForKey:@"temperature"];
        item.summary =[currentWeather valueForKey:@"summary"];
        item.pressure = [currentWeather valueForKey:@"pressure"];
        item.windSpeed = [currentWeather valueForKey:@"windSpeed"];
        currentTime = [currentTime valueForKey:@"time"];
    }
    
    if ([_currentElement valueForKeyPath:@"daily.data"])
    {
        NSArray *dailyWeather = [_currentElement valueForKeyPath:@"daily.data"];
        
        for (NSDictionary *dataItem in dailyWeather)
        {
            if ([currentTime compare:[dataItem valueForKey:@"time"]] == NSOrderedSame)
            {
                item.maxTemperature = [dataItem valueForKey:@"temperatureMax"];
                item.minTemperature = [dataItem valueForKey:@"temperatureMin"];
                
                break;
            }
        }
    }
    
    [_items addObject:item];
}

@end
