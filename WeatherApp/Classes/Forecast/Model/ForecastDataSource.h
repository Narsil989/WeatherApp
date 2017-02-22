//
//  ForecastDataSource.h
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//


#import <Foundation/Foundation.h>
#import "AbstractDataSource.h"

@interface ForecastDataSource : AbstractDataSource

- (void)setUsername:(NSString *)username;
- (void)setMaxRows:(NSString *)maxRows;
- (void)setDarkSkyToken:(NSString *)token;

- (void)getDefaultCityWithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock;

- (void)getUserCityWithData:(NSDictionary *)dataDict andCompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock;

- (void)getUserCityWithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock;

- (void)getCityWithSearchString:(NSString *)searchString WithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock;

- (void)getWeatherWithLongitude:(NSString *)lng andLatitude:(NSString *)lat WithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock;

@end
