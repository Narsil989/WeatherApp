//
//  ForecastDataSource.h
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//


#import <Foundation/Foundation.h>

@interface ForecastDataSource : NSObject

- (void)getCityWithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock;

- (void)getUserCityWithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock;

- (void)getCityWithSearchString:(NSString *)searchString WithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock;

- (void)getWeatherWithLongitude:(NSString *)lng andLatitude:(NSString *)lat WithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock;

@end
