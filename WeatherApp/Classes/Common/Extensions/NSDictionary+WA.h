//
//  NSDictionary+WA.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WA)

- (BOOL)isNull:(NSString *)key;

- (NSString *)getStringWithKey:(NSString *)key;

@end
