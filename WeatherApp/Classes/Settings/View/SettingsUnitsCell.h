//
//  SettingsUnitsCell.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 18/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsUnitsCell : UITableViewCell

@property (nonatomic, copy) void (^valueChanged)();

@end
