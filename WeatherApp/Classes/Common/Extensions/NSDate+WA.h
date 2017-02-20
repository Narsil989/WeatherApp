//
//  NSDate+WA.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WA)

+ (NSDate *)dateFromUnixTime:(NSNumber *)unixTime;

@end
