//
//  AbstractParser.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "AbstractParser.h"

@implementation AbstractParser

- (void)parseData:(id)data
{
    id jsonObject = nil;
    
    _items = [NSMutableArray new];
    
    if ([data isKindOfClass:[NSData class]])
    {
        NSError *error = nil;
        
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    }
    else
    {
        jsonObject = data;
    }
    
    if (jsonObject)
    {
        _rootJsonObject = jsonObject;
        
        if (_rootJsonObject)
        {
            if ([_rootJsonObject isKindOfClass:[NSDictionary class]])
            {
                _currentElement = _rootJsonObject;
                [self bindObject];
            }
            else if ([_rootJsonObject isKindOfClass:[NSArray class]])
            {
                for (id item in _rootJsonObject)
                {
                    if ([item isKindOfClass:[NSDictionary class]])
                    {
                        _currentElement = item;
                        [self bindObject];
                    }
                }
            }
        }
    }
    else
    {
        
    }
    
}

- (void)bindObject
{
    
}

- (NSArray *)itemsArray
{
    return [NSArray arrayWithArray:_items];
}

@end
