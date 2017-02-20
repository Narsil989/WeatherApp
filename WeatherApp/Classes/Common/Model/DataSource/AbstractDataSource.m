//
//  AbstractDataSource.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 18/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "AbstractDataSource.h"
#import "AbstractParser.h"

@implementation AbstractDataSource

static NSString* _baseUrl;

#pragma mark - Setters

+ (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = [NSString stringWithString:baseUrl];
}

- (void)getDataWithParameters:(NSDictionary *)parameters parserClass:(Class)parserClass andCompletionBlock:(void (^)(BOOL success, NSError *error, NSArray *dataArray))completionBlock
{
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:666 userInfo:@{@"error": @"Please add valid parser class"}];
    if (!_baseUrl.length || !parserClass)
        if (completionBlock)
        {
            if (!parserClass)
                completionBlock(NO, error, nil);
            else
                completionBlock(NO, nil, nil);
        }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:_baseUrl parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        AbstractParser *parser = [parserClass new];
        [parser parseData:responseObject];
        
        if (completionBlock) completionBlock(YES, nil, [parser itemsArray]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if (completionBlock) completionBlock(NO, error, nil);
    }];
    
}


@end
