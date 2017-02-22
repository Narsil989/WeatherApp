//
//  CommonAlertView.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 22/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonAlertView : NSObject

+ (void)showCommonAlertViewOnController:(UIViewController *)controller withTitle:(NSString *)title andMessage:(NSString *)message;

@end
