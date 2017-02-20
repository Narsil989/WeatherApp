//
//  UIColor+WA.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "UIColor+WA.h"

@implementation UIColor (WA)

+ (UIColor *)getColorFromIconString:(NSString *)colorString
{
    if ([colorString isEqualToString:@"clear-day"])
        return [UIColor flatYellowColor];
    else if ([colorString isEqualToString:@"clear-night"])
        return [UIColor flatGreenColorDark];
    else if ([colorString isEqualToString:@"cloudy"])
        return [UIColor flatBlueColor];
    else if ([colorString isEqualToString:@"fog"])
        return [UIColor flatPurpleColor];
    else if ([colorString isEqualToString:@"hail"])
        return [UIColor flatSkyBlueColor];
    else if ([colorString isEqualToString:@"partly-cloudy-day"])
        return [UIColor flatForestGreenColor];
    else if ([colorString isEqualToString:@"partly-cloudy-night"])
        return [UIColor flatOrangeColor];
    else if ([colorString isEqualToString:@"rain"])
        return [UIColor flatNavyBlueColor];
    else if ([colorString isEqualToString:@"sleet"])
        return [UIColor flatPowderBlueColor];
    else if ([colorString isEqualToString:@"snow"])
        return [UIColor flatLimeColor];
    else if ([colorString isEqualToString:@"thunderstorm"])
        return [UIColor flatBrownColor];
    else if ([colorString isEqualToString:@"wind"])
        return [UIColor flatRedColor];
    
    else return [UIColor clearColor];
}


@end
