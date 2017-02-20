//
//  NSDictionary+WA.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "NSDictionary+WA.h"

@implementation NSDictionary (WA)

- (BOOL)isNull:(NSString *)key
{
    return [[self objectForKey:key] isKindOfClass:[NSNull class]];
}

- (NSString *)getStringWithKey:(NSString *)key
{
    return [self isNull:key] ? nil : [self objectForKey:key];
}

@end
