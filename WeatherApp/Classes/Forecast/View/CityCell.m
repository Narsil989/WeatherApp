//
//  CityCell.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "CityCell.h"

@implementation CityCell
{
    __weak IBOutlet UILabel *_letterLabel;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIView *_borderView;
    __weak IBOutlet NSLayoutConstraint *_borderViewHeightConstraint;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self bindGUI];
    
    [self applyStyle];
    // Initialization code
}

- (void)applyStyle
{
    [WAStyle applyStyle:@"City_Label_Title" toLabel:_letterLabel];
    [WAStyle applyStyle:@"City_Label_Title" toLabel:_titleLabel];
    _borderViewHeightConstraint.constant = 1./[UIScreen mainScreen].scale;
    
}

- (void)bindGUI
{
    if (_city)
    {
        _letterLabel.text = [_city.name substringWithRange:NSMakeRange(0, 1)];
        _titleLabel.text = [NSString stringWithFormat:@"%@, %@", _city.name, _city.countryCode];
        _letterLabel.backgroundColor = _borderView.backgroundColor = [UIColor randomFlatColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCity:(City *)city
{
    _city = city;
    
    [self bindGUI];
}

@end
