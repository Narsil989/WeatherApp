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
    __weak IBOutlet UIImageView *_checkmarkImageView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyStyle];
    [self bindGUI];
}

- (void)applyStyle
{
    [WAStyle applyFontStyle:@"Settings_Title_Label_Selected" toButton:_checkmarkButton forState:UIControlStateSelected];
    [WAStyle applyFontStyle:@"Settings_Title_Label" toButton:_checkmarkButton forState:UIControlStateNormal];
}

- (void)bindGUI
{
    [self bindTitleLabel];
    [self updateImage];
}

- (void)bindTitleLabel
{
    if (_titleString.length)
        [_checkmarkButton setTitle:_titleString forState:UIControlStateNormal];
}

- (void)bindButton
{
    if (_conditionType == Humidity)
        _checkmarkButton.selected = [ConfigManager isHumidityShown];
    else if (_conditionType == Pressure)
        _checkmarkButton.selected = [ConfigManager isPressureShown];
    else if (_conditionType == WindSpeed)
        _checkmarkButton.selected = [ConfigManager isWindSpeedShown];
    
    [self updateImage];
}

- (void)setConditionType:(ConditionType)conditionType
{
    _conditionType = conditionType;
    
    [self bindButton];
    [self updateImage];
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
    
    [self updateImage];
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
    
    if (_updateConditionsOnMainScreen)
        _updateConditionsOnMainScreen();
}

- (void)updateImage
{
    _checkmarkImageView.image = [UIImage imageNamed:_checkmarkButton.selected ? @"CheckMark" : @"CheckMarkUnchecked"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
