//
//  LoadingView.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 17/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

#pragma mark - init methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // load view frame XIB
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // load view frame XIB
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil)
    {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        self.containerView.layer.cornerRadius = 5.0;
        [WAStyle applyStyle:@"Loading_Title_Label" toLabel:self.titleLabel];
        [self addSubview:view];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - Show loading view methods

+ (instancetype)showLoadingViewInView:(UIView *)view WithCompletionBlock:(LoadingViewCompletionBlock)completionBlock
{
    LoadingView *loading = [[LoadingView alloc] initWithFrame:view.bounds];
    
    loading.titleLabel.text = @"Hold my beer";
    [view addSubview:loading];
    
    [loading showLoadingWithCompletionBlock:^{
        
        if(completionBlock)
            completionBlock();
    }];
    
    return loading;
}


+ (instancetype)showLoadingViewInView:(UIView *)view
{
    LoadingView *loading = [[LoadingView alloc] initWithFrame:view.bounds];

    loading.titleLabel.text = @"Hold my beer";
    
    [view addSubview:loading];

    [loading showLoading];

    return loading;
}

- (void)showLoading
{
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
    
    [self.mainTimer invalidate];
    self.mainTimer = nil;
    
    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.mainTimer forMode:NSRunLoopCommonModes];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)showLoadingWithCompletionBlock:(LoadingViewCompletionBlock)completionBlock
{
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
    
    [self.mainTimer invalidate];
    self.mainTimer = nil;
    
    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.mainTimer forMode:NSRunLoopCommonModes];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            if (completionBlock)
                completionBlock();
        }
    }];
    
}

#pragma mark - Hide loading view methods

+ (void)hideLoadingViewForView:(UIView *)view
{
    LoadingView *loading = [self loadingViewForView:view];
    
    if (loading != nil)
    {
        [loading hideLoading];
    }
}

+ (void)hideLoadingViewForView:(UIView *)view WithCompletionBlock:(LoadingViewCompletionBlock)completionBlock
{
    LoadingView *loading = [self loadingViewForView:view];
    
    if (loading != nil)
    {
        [loading hideLoadingWithCompletionBlock:^{
            
            if (completionBlock)
                completionBlock();
        }];
    }
    else
        if (completionBlock)
            completionBlock();
}

- (void)hideLoading
{
    self.alpha = 1;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, .01, .01);
        
        
    } completion:^(BOOL finished) {
        
        [self.mainTimer invalidate];
        [self removeFromSuperview];
        
    }];
}
- (void)hideLoadingWithCompletionBlock:(LoadingViewCompletionBlock)completionBlock
{
    self.alpha = 1;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, .01, .01);
        
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [self.mainTimer invalidate];
            [self removeFromSuperview];
            
            if (completionBlock)
                completionBlock();
        }
        
        
    }];
}

+ (LoadingView *)loadingViewForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (LoadingView *)subview;
        }
    }
    return nil;
}

- (void)onTick:(NSTimer *)timer
{
    if ([self.titleLabel.text isEqualToString:@"Hold my beer"]) {
        self.titleLabel.text = @"Hold my beer.";
    } else if ([self.titleLabel.text isEqualToString:@"Hold my beer."]) {
        self.titleLabel.text = @"Hold my beer..";
    } else if ([self.titleLabel.text isEqualToString:@"Hold my beer.."]) {
        self.titleLabel.text = @"Hold my beer...";
    }else if ([self.titleLabel.text isEqualToString:@"Hold my beer..."]) {
        self.titleLabel.text = @"Hold my beer";
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self.mainTimer invalidate];
    self.mainTimer = nil;
}

@end
