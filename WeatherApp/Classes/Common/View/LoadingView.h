//
//  LoadingView.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

typedef void (^LoadingViewCompletionBlock)();

+ (instancetype)showLoadingViewInView:(UIView *)view;
+ (instancetype)showLoadingViewInView:(UIView *)view WithCompletionBlock:(LoadingViewCompletionBlock)completionBlock;

+ (void)hideLoadingViewForView:(UIView *)view;
+ (void)hideLoadingViewForView:(UIView *)view WithCompletionBlock:(LoadingViewCompletionBlock)completionBlock;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSTimer *mainTimer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
