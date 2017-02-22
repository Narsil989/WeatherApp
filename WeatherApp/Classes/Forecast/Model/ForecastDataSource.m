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
#import "CityEntityParser.h"
#import "WeatherParser.h"

#define geoname_search @"searchJSON"
#define geoname_nearby_place @"findNearbyPlaceNameJSON"

@implementation ForecastDataSource
{
    AbstractDataSource *_geonameDS;
    AbstractDataSource *_darkSkyDS;
}

static NSString* _username;
static NSString* _maxRows;
static NSString* _darkskyToken;

- (void)setUsername:(NSString *)username
{
    _username = [NSString stringWithString:username];
}

- (void)setMaxRows:(NSString *)maxRows
{
    _maxRows = [NSString stringWithString:maxRows];
}

- (void)setDarkSkyToken:(NSString *)token
{
    _darkskyToken = token;
}

- (NSString *)getSearchUrl
{
    return [geoname_base_url stringByAppendingString:geoname_search];
}

- (NSString *)getNearbyPlaceUrl
{
    return [geoname_base_url stringByAppendingString:geoname_nearby_place];
}

- (NSString *)adaptForecastUrlWithLatitude:(NSString *)lat andLogitude:(NSString *)lng
{
    if (!_darkskyToken.length) return nil;
    
    NSMutableString *urlString = [NSMutableString new];
    
    [urlString appendString:dark_sky_base_url];
    [urlString appendString:_darkskyToken];
    [urlString appendString:@"/"];
    [urlString appendString:lat];
    [urlString appendString:@","];
    [urlString appendString:lng];
    
    return urlString;
}

- (void)getDefaultCityWithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock
{
    [AbstractDataSource setBaseUrl:[self getSearchUrl]];
    
    if (!_geonameDS) _geonameDS = [AbstractDataSource new];
    
    [_geonameDS getDataWithParameters:@{@"q" : @"Osijek",
                                        @"maxRows" : @"1",//_maxRows.length ? _maxRows : @"10",
                                        @"username": @"narsil"}
                          parserClass:[CityEntityParser class] andCompletionBlock:^(BOOL success, NSError *error, NSArray *dataArray) {
       
        if (completionBlock)
            completionBlock(success, error, dataArray);
        
    }];
    
}

- (void)getUserCityWithData:(NSDictionary *)dataDict andCompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock
{
    [AbstractDataSource setBaseUrl:[self getNearbyPlaceUrl]];
    
    NSString *lng = [dataDict valueForKey:@"longitude"];
    NSString *lat = [dataDict valueForKey:@"latitude"];
    
    if (!_geonameDS) _geonameDS = [AbstractDataSource new];
    
    if (!lng || !lat || !lng.length || !lat.length)
    {
        if (completionBlock)
            completionBlock(NO, nil, nil);
        return;
    }
    
    [_geonameDS getDataWithParameters:@{@"lat" : lat,
                                        @"lng" : lng,
                                        @"username": @"narsil"}
                          parserClass:[CityEntityParser class] andCompletionBlock:^(BOOL success, NSError *error, NSArray *dataArray) {
                              
                              if (completionBlock)
                                  completionBlock(success, error, dataArray);
                              
                          }];
    
}

- (void)getCityWithSearchString:(NSString *)searchString WithcompletionBlock:(void (^)(BOOL done, NSError *err, NSArray *arr))completionBlock
{
    if (!searchString.length)
    {
        if (completionBlock)
            completionBlock(NO, nil, nil);
        
        return;
    }
    
    [AbstractDataSource setBaseUrl:[self getSearchUrl]];
    
    if (!_geonameDS) _geonameDS = [AbstractDataSource new];
    
    [_geonameDS getDataWithParameters:@{@"q" : searchString,
                                        @"maxRows" : _maxRows.length ? _maxRows : @"10",
                                        @"username": _username}
                          parserClass:[CityParser class] andCompletionBlock:^(BOOL success, NSError *error, NSArray *dataArray) {
        
        if (completionBlock)
            completionBlock(success, error, dataArray);
        
    }];

    
}


- (void)getWeatherWithLongitude:(NSString *)lng andLatitude:(NSString *)lat WithcompletionBlock:(void (^)(BOOL, NSError *, NSArray *))completionBlock
{
    if (!lng.length || !lat.length || !lat || !lng || !_darkskyToken.length)
    {
        if (completionBlock)
            completionBlock(NO, nil, nil);
        
        return;
    }
    if (!_darkSkyDS) _darkSkyDS = [AbstractDataSource new];
    
    [AbstractDataSource setBaseUrl:[self adaptForecastUrlWithLatitude:lat andLogitude:lng]];
    
    NSString *unitKey;
    
    if ([[ConfigManager.settingsDict valueForKey:unit_si_key] boolValue])
        unitKey = @"si";
    else if([[ConfigManager.settingsDict valueForKey:unit_us_key] boolValue])
        unitKey = @"us";
    else
        unitKey = @"si";
    
    NSMutableDictionary *unitDict = [NSMutableDictionary new];
    unitDict[@"units"] = unitKey;
    
    [_darkSkyDS getDataWithParameters:unitDict parserClass:[WeatherParser class] andCompletionBlock:^(BOOL success, NSError *error, NSArray *dataArray) {
    
        if (completionBlock) completionBlock(success, error, dataArray);
        
    }];
}

@end
