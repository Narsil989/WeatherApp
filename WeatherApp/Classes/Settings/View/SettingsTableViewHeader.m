//
//  SettingsTableViewHeader.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "SettingsTableViewHeader.h"

@implementation SettingsTableViewHeader
{
    __weak IBOutlet UILabel *_titleLabel;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyStyle];
    [self bindGUI];
    
}

- (void)applyStyle
{
    [WAStyle applyStyle:@"Settings_Title_Label" toLabel:_titleLabel];
}

- (void)bindGUI
{
    if (_titleString.length)
        _titleLabel.text = _titleString;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    [self bindGUI];
}

@end
