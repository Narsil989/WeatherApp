//
//  Style.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WAStyle : NSObject

+ (void)applyStyle:(NSString *)key toLabel:(UILabel *)label;
+ (UIColor *)colorForKey:(NSString *)key;
+ (void)applyFontStyle:(NSString *)key toButton:(UIButton *)button forState:(UIControlState)state;
+ (UIFont *)fontForKey:(NSString *)key;



@end
