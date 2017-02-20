//
//  SettingsCityCell.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCityCell : UITableViewCell

@property (nonatomic, strong) CityEntity *cityEntitiy;

@property (nonatomic, copy) void (^deleteCityButtonTapped)(CityEntity *deletedCity);

@end
