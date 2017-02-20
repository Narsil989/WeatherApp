//
//  ForecastDataSource.m
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import "ForecastDataSource.h"
#import <AFNetworking.h>
#import "CityParser.h"
#import "WeatherParser.h"

@implementation ForecastDataSource


- (void)getCityWithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *getUrl = @"http://api.geonames.org/searchJSON?q=Osijek&maxRows=10&username=narsil";
    
    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        CityParser *parser = [CityParser new];
        [parser parseData:responseObject];
        
        if (completionBlock) completionBlock(YES, nil, [parser itemsArray]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if (completionBlock) completionBlock(NO, error, nil);
    }];
    
}

- (void)getUserCityWithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *getUrl =[NSString stringWithFormat:@"http://api.geonames.org/findNearbyPlaceNameJSON?lat=%@&lng=%@&username=narsil", ConfigManager.userCity.latitude, ConfigManager.userCity.longitude];
    
    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        CityParser *parser = [CityParser new];
        [parser parseData:responseObject];
        
        if (completionBlock) completionBlock(YES, nil, [parser itemsArray]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if (completionBlock) completionBlock(NO, error, nil);
    }];
    
}

- (void)getCityWithSearchString:(NSString *)searchString WithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock
{
    if (!searchString.length)
    {
        if (completionBlock)
            completionBlock(NO, nil, nil);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?q=%@&maxRows=10&username=narsil", searchString];
    
    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        CityParser *parser = [CityParser new];
        [parser parseData:responseObject];
        
        if (completionBlock) completionBlock(YES, nil, [parser itemsArray]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if (completionBlock) completionBlock(NO, error, nil);
    }];
    
}


- (void)getWeatherWithLongitude:(NSString *)lng andLatitude:(NSString *)lat WithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *urlString = [NSMutableString new];
    
    [urlString appendString:@"https://api.darksky.net/forecast/c445625667ffb6939409211d3255ff87/"];
    [urlString appendString:lat];
    [urlString appendString:@","];
    [urlString appendString:lng];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        WeatherParser *parser = [WeatherParser new];
        [parser parseData:responseObject];
        
        if (completionBlock) completionBlock(YES, nil, [parser itemsArray]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if (completionBlock) completionBlock(NO, error, nil);
    }];
    
}

@end
