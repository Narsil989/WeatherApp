//
//  AbstractDataSource.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 18/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractDataSource : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (void)setBaseUrl:(NSString *)baseUrl;

- (void)getDataWithParameters:(NSDictionary *)parameters parserClass:(Class)parserClass andCompletionBlock:(void (^)(BOOL success, NSError *error, NSArray *dataArray))completionBlock;

@end
