//
//  SettingsCityCell.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "SettingsCityCell.h"

@implementation SettingsCityCell
{
    __weak IBOutlet UILabel *_cityNameLabel;
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyStyle];
    [self bindGUI];
}

- (void)applyStyle
{
    [WAStyle applyStyle:@"Settings_Title_Label" toLabel:_cityNameLabel];
}

- (void)bindGUI
{
    if (_cityEntitiy)
    {
        _cityNameLabel.text = _cityEntitiy.name;
        self.selected = _cityEntitiy.isSelected;
    }
}

- (IBAction)deleteButtonTapped:(id)sender
{
    if (_deleteCityButtonTapped)
        _deleteCityButtonTapped(_cityEntitiy);
}

- (void)setCityEntitiy:(CityEntity *)cityEntitiy
{
    _cityEntitiy = cityEntitiy;
    
    [self bindGUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
