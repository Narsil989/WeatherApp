//
//  CityEntityParser.m
//  WeatherApp
//
//  Created by Dejan Kraguljac  on 19/02/17.
//  Copyright © 2017 Dejan Kraguljac . All rights reserved.
//

#import "CityEntityParser.h"

@implementation CityEntityParser

- (void)bindObject
{
    
    /*
     
     "adminCode1": "10",
     "lng": "18.69389",
     "geonameId": 3193935,
     "toponymName": "Osijek",
     "countryId": "3202326",
     "fcl": "P",
     "population": 88140,
     "countryCode": "HR",
     "name": "Osijek",
     "fclName": "city, village,...",
     "countryName": "Croatia",
     "fcodeName": "seat of a first-order administrative division",
     "adminName1": "Osječko-Baranjska",
     "lat": "45.55111",
     "fcode": "PPLA"
     
     */
    
    if ([_currentElement objectForKey:@"geonames"])
    {
        for (NSDictionary *item in [_currentElement objectForKey:@"geonames"])
        {
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CityEntity class])
                                                      inManagedObjectContext:[DataManager mainManagedObjectContext]];
            
            NSManagedObjectContext *testManagedObjectContext = [DataManager mainManagedObjectContext];
            NSArray *tempArray = [DataManager citiesForSearchQuery:[NSString stringWithFormat:@"geonameId == %f", [[item valueForKey:@"geonameId"] floatValue]]];
            
            if ([tempArray count] == 0)
            {
                CityEntity *userCity = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:testManagedObjectContext];
                
                userCity.name = [item valueForKey:@"toponymName"];
                userCity.countryCode = [item valueForKey:@"countryCode"];
                userCity.geonameId = [[item valueForKey:@"geonameId"] floatValue];
                userCity.isSelected = NO;
                userCity.longitude = [item valueForKey:@"lng"];
                userCity.latitude = [item valueForKey:@"lat"];
                
                [_items addObject:userCity];
            }
            else
                [_items addObject:[tempArray firstObject]];
            
            
            [testManagedObjectContext save:nil];
            
            break;
            
        }
    }
}

@end
