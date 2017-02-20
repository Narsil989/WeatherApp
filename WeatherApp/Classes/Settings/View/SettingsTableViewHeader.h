//
//  SettingsTableViewHeader.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) NSString *titleString;

@end
