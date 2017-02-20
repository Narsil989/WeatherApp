//
//  AbstractParser.h
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 16/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+WA.h"
#import "NSDictionary+WA.h"

@interface AbstractParser : NSObject
{
    id _rootJsonObject;
    
    NSDictionary *_currentElement;
    
    NSMutableArray *_items;
}
- (void)parseData:(id)data;
- (NSArray *)itemsArray;
- (void)bindObject;

@end
