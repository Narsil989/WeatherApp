//
//  SettingsViewController.h
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, copy) void (^shouldRefreshWeather)();


@end
