//
//  SettingsUnitsCell.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 18/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "SettingsUnitsCell.h"

@implementation SettingsUnitsCell
{
    __weak IBOutlet UIButton *_metricButton;
    __weak IBOutlet UIButton *_imperialButton;
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyStyle];
    [self bindGUI];
}

- (void)applyStyle
{
    [WAStyle applyFontStyle:@"Settings_Title_Label" toButton:_metricButton forState:UIControlStateNormal];
    [WAStyle applyFontStyle:@"Settings_Title_Label_Selected" toButton:_metricButton forState:UIControlStateSelected];
    [WAStyle applyFontStyle:@"Settings_Title_Label" toButton:_imperialButton forState:UIControlStateNormal];
    [WAStyle applyFontStyle:@"Settings_Title_Label_Selected" toButton:_imperialButton forState:UIControlStateSelected];
    
    [_metricButton sizeToFit];
    [_imperialButton sizeToFit];
}

- (void)bindGUI
{
    _metricButton.selected = [[ConfigManager.settingsDict valueForKeyPath:unit_si_key] boolValue];
    _imperialButton.selected = [[ConfigManager.settingsDict valueForKeyPath:unit_us_key] boolValue];
    [self bindButtonTitles];
    [self bindButtonImages];
}

- (void)bindButtonTitles
{
    [_metricButton setTitle:@"Metric" forState:UIControlStateNormal];
    [_imperialButton setTitle:@"Imperial" forState:UIControlStateNormal];
    
    [_metricButton sizeToFit];
    [_imperialButton sizeToFit];
}

- (void)bindButtonImages
{
    [_metricButton setImage:[[UIImage imageNamed:@"MetricIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_metricButton setTintColor:_metricButton.selected ? [WAStyle colorForKey:@"Settings_Title_Label_Selected"] : [WAStyle colorForKey:@"Settings_Title_Label"]];
    [_imperialButton setImage:[[UIImage imageNamed:@"ImperialIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_imperialButton setTintColor:_imperialButton.selected ? [WAStyle colorForKey:@"Settings_Title_Label_Selected"] : [WAStyle colorForKey:@"Settings_Title_Label"]];
}

- (IBAction)metricButtonTapped:(id)sender
{
    _metricButton.selected = !_metricButton.selected;
    if (_metricButton.selected && _imperialButton.selected) _imperialButton.selected = !_imperialButton.selected;
    
    [self updateSettingsDict];
    [self updateButtons];
}

- (IBAction)imperialButtonTapped:(id)sender
{
    _imperialButton.selected = !_imperialButton.selected;
    if (_metricButton.selected && _imperialButton.selected) _metricButton.selected = !_metricButton.selected;
    
    [self updateSettingsDict];
    [self updateButtons];
}

- (void)updateButtons
{
    [_metricButton setTintColor:_metricButton.selected ? [WAStyle colorForKey:@"Settings_Title_Label_Selected"] : [WAStyle colorForKey:@"Settings_Title_Label"]];
    [_imperialButton setTintColor:_imperialButton.selected ? [WAStyle colorForKey:@"Settings_Title_Label_Selected"] : [WAStyle colorForKey:@"Settings_Title_Label"]];
}

- (void)updateSettingsDict
{
    [ConfigManager.settingsDict setValue:@(_metricButton.selected) forKey:unit_si_key];
    [ConfigManager.settingsDict setValue:@(_imperialButton.selected) forKey:unit_us_key];
    
    [ConfigManager saveChangesOnConfigurationDict];
    
    if (_valueChanged)
        _valueChanged();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
