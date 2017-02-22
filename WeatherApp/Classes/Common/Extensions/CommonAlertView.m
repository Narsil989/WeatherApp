//
//  CommonAlertView.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 22/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "CommonAlertView.h"

@implementation CommonAlertView

+ (void)showCommonAlertViewOnController:(UIViewController *)controller withTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
