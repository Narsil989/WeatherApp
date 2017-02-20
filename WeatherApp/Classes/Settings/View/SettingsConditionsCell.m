//
//  SettingsContitionsCell.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "SettingsConditionsCell.h"

@implementation SettingsConditionsCell
{
    __weak IBOutlet UIButton *_checkmarkButton;
    __weak IBOutlet UILabel *_conditionLabel;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyStyle];
    [self bindGUI];
}

- (void)applyStyle
{
    [WAStyle applyStyle:@"Settings_Title_Label" toLabel:_conditionLabel];
}

- (void)bindGUI
{
    [self bindTitleLabel];
    [self updateLabelStyle];
}

- (void)bindTitleLabel
{
    if (_titleString.length)
        _conditionLabel.text = _titleString;
}

- (void)bindButton
{
    if (_conditionType == Humidity)
        _checkmarkButton.selected = [[ConfigManager.settingsDict valueForKeyPath:condition_humidity_key_path] boolValue];
    else if (_conditionType == Pressure)
        _checkmarkButton.selected = [[ConfigManager.settingsDict valueForKeyPath:condition_pressure_key_path] boolValue];
    else if (_conditionType == WindSpeed)
        _checkmarkButton.selected = [[ConfigManager.settingsDict valueForKeyPath:condition_wind_speed_key_path] boolValue];
}

- (void)setConditionType:(ConditionType)conditionType
{
    _conditionType = conditionType;
    
    [self bindButton];
    [self updateLabelStyle];
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    [self bindGUI];
}

- (IBAction)checkmarkButtonTapped:(id)sender
{
    _checkmarkButton.selected = !_checkmarkButton.selected;
    
    [self updateSettingsDict];
    
    [self updateLabelStyle];
}

- (void)updateSettingsDict
{
    if (_conditionType == Humidity)
        [ConfigManager.settingsDict setValue:@(_checkmarkButton.selected) forKeyPath:condition_humidity_key_path];
    if (_conditionType == Pressure)
        [ConfigManager.settingsDict setValue:@(_checkmarkButton.selected) forKeyPath:condition_pressure_key_path];
    if (_conditionType == WindSpeed)
        [ConfigManager.settingsDict setValue:@(_checkmarkButton.selected) forKeyPath:condition_wind_speed_key_path];

    [ConfigManager saveChangesOnConfigurationDict];
}

- (void)updateLabelStyle
{
    [WAStyle applyStyle:_checkmarkButton.selected ? @"Settings_Title_Label_Selected" : @"Settings_Title_Label" toLabel:_conditionLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
