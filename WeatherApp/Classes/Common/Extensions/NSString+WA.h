//
//  NSString+WA.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WA)

//maybe make enum for unit
+ (NSString *)temperatureString:(NSString *)value;
+ (NSString *)windSpeedString:(NSString *)value;
@end
