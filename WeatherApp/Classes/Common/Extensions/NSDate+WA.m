//
//  NSDate+WA.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "NSDate+WA.h"

@implementation NSDate (WA)

+ (NSDate *)dateFromUnixTime:(NSNumber *)unixTime
{
    double timestampval =  [unixTime doubleValue]/1000;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

@end
