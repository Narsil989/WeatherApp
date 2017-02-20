//
//  LoadingViewController.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 18/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController

@property (nonatomic, copy) void (^loadDataFinished)();

@end
