//
//  SettingsContitionsCell.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ConditionType) {
    Humidity = 0,
    WindSpeed,
    Pressure
};


@interface SettingsConditionsCell : UITableViewCell

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic) ConditionType conditionType;
@property (nonatomic, copy) void (^updateConditionsOnMainScreen)();


@end
