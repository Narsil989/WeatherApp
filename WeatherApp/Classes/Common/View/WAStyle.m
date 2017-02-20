//
//  Style.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "WAStyle.h"

static NSString *_styleDictPath = @"Style_Fonts.plist";

@implementation WAStyle

+ (void)applyStyle:(NSString *)key toLabel:(UILabel *)label
{
    NSDictionary *styleDict = [self styleDict];
    
    if (!styleDict)
    {
        return;
    }
    
    NSDictionary *dictionary = [styleDict valueForKeyPath:key];
    
    if (!dictionary)
    {
        NSLog(@"%@: style %@ not found", [self.class description], key);
        return;
    }
    
    label.font = [UIFont fontWithName:[dictionary valueForKey:@"font"] size:[(NSNumber *)[dictionary valueForKey:@"font_size"] floatValue]];
    
    label.textColor = [UIColor colorWithRed:[(NSNumber *)[dictionary valueForKey:@"font_color_red"] floatValue] / 255.0
                                      green:[(NSNumber *)[dictionary valueForKey:@"font_color_green"] floatValue] / 255.0
                                       blue:[(NSNumber *)[dictionary valueForKey:@"font_color_blue"] floatValue] / 255.0
                                      alpha:[(NSNumber *)[dictionary valueForKey:@"font_color_opacity"] floatValue]];
    
    label.shadowOffset = CGSizeMake([(NSNumber *)[dictionary valueForKey:@"shadow_offset_width"] floatValue], [(NSNumber *)[dictionary valueForKey:@"shadow_offset_height"] floatValue]);
    
    label.shadowColor = [UIColor colorWithRed:[(NSNumber *)[dictionary valueForKey:@"shadow_color_red"] floatValue] / 255.0
                                        green:[(NSNumber *)[dictionary valueForKey:@"shadow_color_green"] floatValue] / 255.0
                                         blue:[(NSNumber *)[dictionary valueForKey:@"shadow_color_blue"] floatValue] / 255.0
                                        alpha:[(NSNumber *)[dictionary valueForKey:@"shadow_color_opacity"] floatValue]];
}

+ (UIColor *)colorForKey:(NSString *)key
{
    NSDictionary *styleDict = [self styleDict];
    
    if (!styleDict)
    {
        return [UIColor blackColor];
    }
    
    NSDictionary *dictionary = [styleDict valueForKeyPath:key];
    
    if (!dictionary)
    {
        NSLog(@"%@: style %@ not found", [self.class description], key);
        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:[(NSNumber *)[dictionary valueForKey:@"font_color_red"] floatValue] / 255.0
                           green:[(NSNumber *)[dictionary valueForKey:@"font_color_green"] floatValue] / 255.0
                            blue:[(NSNumber *)[dictionary valueForKey:@"font_color_blue"] floatValue] / 255.0
                           alpha:[(NSNumber *)[dictionary valueForKey:@"font_color_opacity"] floatValue]];
}

+ (void)applyFontStyle:(NSString *)key toButton:(UIButton *)button forState:(UIControlState)state
{
    NSDictionary *styleDict = [self styleDict];
    
    if (!styleDict)
    {
        return;
    }
    
    NSDictionary *dictionary = [styleDict valueForKeyPath:key];
    
    if (!dictionary)
    {
        NSLog(@"%@: style %@ not found", [self.class description], key);
        return;
    }
    
    button.titleLabel.font = [UIFont fontWithName:[dictionary valueForKey:@"font"] size:[(NSNumber *)[dictionary valueForKey:@"font_size"] floatValue]];
    
    [button setTitleColor:[UIColor colorWithRed:[(NSNumber *)[dictionary valueForKey:@"font_color_red"] floatValue] / 255.0
                                          green:[(NSNumber *)[dictionary valueForKey:@"font_color_green"] floatValue] / 255.0
                                           blue:[(NSNumber *)[dictionary valueForKey:@"font_color_blue"] floatValue] / 255.0
                                          alpha:[(NSNumber *)[dictionary valueForKey:@"font_color_opacity"] floatValue]]
                 forState:state];
    
    [button setTitleShadowColor:[UIColor colorWithRed:[(NSNumber *)[dictionary valueForKey:@"shadow_color_red"] floatValue] / 255.0
                                                green:[(NSNumber *)[dictionary valueForKey:@"shadow_color_green"] floatValue] / 255.0
                                                 blue:[(NSNumber *)[dictionary valueForKey:@"shadow_color_blue"] floatValue] / 255.0
                                                alpha:[(NSNumber *)[dictionary valueForKey:@"shadow_color_opacity"] floatValue]]
                       forState:state];
    
    button.titleLabel.shadowOffset = CGSizeMake([(NSNumber *)[dictionary valueForKey:@"shadow_offset_width"] floatValue], [(NSNumber *)[dictionary valueForKey:@"shadow_offset_height"] floatValue]);
}


+ (NSDictionary *)styleDict
{
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_styleDictPath ofType:nil]];
}

@end
