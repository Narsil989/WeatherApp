//
//  NSString+WA.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "NSString+WA.h"

@implementation NSString (WA)

+ (NSString *)temperatureString:(NSString *)value
{
    NSString *unitKey;
    
    if ([[ConfigManager.settingsDict valueForKey:unit_si_key] boolValue])
        unitKey = @"°C";
    else if([[ConfigManager.settingsDict valueForKey:unit_us_key] boolValue])
        unitKey = @"°F";
    else
        unitKey = @"°C";
    return [NSString stringWithFormat:@"%@%@", value, unitKey];
}

+ (NSString *)windSpeedString:(NSString *)value
{
    NSString *unitKey;
    if ([[ConfigManager.settingsDict valueForKey:unit_si_key] boolValue])
        unitKey = @" km/h";
    else if([[ConfigManager.settingsDict valueForKey:unit_us_key] boolValue])
        unitKey = @" mph";
    else
        unitKey = @" km/h";
    return [NSString stringWithFormat:@"%@%@", value, unitKey];
    
}

@end
