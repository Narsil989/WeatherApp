//
//  CoreDataManager.h
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)sharedManager;

- (NSManagedObjectContext *)createBackgroundContext;

- (NSArray *)citiesForSearchQuery:(NSString *)query;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)setMainCitySelectAndDeselctOther:(CityEntity *)mainCity;
@end
