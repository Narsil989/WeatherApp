//
//  CityParser.m
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import "CityParser.h"
#import "CoreDataManager.h"

@implementation CityParser

- (void)bindObject
{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityEntity"
//                                              inManagedObjectContext:[[CoreDataManager sharedManager] createBackgroundContext]];
//    
//    CityEntity *item = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:[[CoreDataManager sharedManager] createBackgroundContext]];

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
            City *currentCity = [City new];
            
            currentCity.geonameId = [item valueForKey:@"geonameId"];
            currentCity.name = [item valueForKey:@"toponymName"];
            currentCity.longitude  = [item valueForKey:@"lng"];
            currentCity.latitude = [item valueForKey:@"lat"];
            currentCity.countryCode = [item valueForKey:@"countryCode"];
            
            [_items addObject:currentCity];
        }
    }
}

@end
