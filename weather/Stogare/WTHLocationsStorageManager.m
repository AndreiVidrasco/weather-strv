//
//  WTHLocationsManager.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHLocationsStorageManager.h"
#import "LocationEntity.h"

@implementation WTHLocationsStorageManager

+ (instancetype)sharedManager {
    static dispatch_once_t pred;
    static id sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (void)insertLocationIntoDatabaseIfNew:(WTHLocationEntityModel *)location {
    if (!location) return;
    NSInteger indexOfObjectInDatabase = [self indexOfObjectInDatabaseLatitude:location.latitude
                                                                    longitude:location.longitude
                                                            isCurrentLocation:location.isCurrentLocation];
    if (indexOfObjectInDatabase == NSNotFound) {
        [self insertGeolocationInDatabse:location];
    } else {
        NSArray *recentSearches = [self fetchLocations];
        LocationEntity *dbEntity = recentSearches[indexOfObjectInDatabase];
        dbEntity.temperatureValueC = location.temperatureValueC;
        dbEntity.temperatureValueF = location.temperatureValueF;
        dbEntity.weatherDescription = location.weatherDescription;
        if (location.isCurrentLocation) {
            dbEntity.address = location.address;
        }
        dbEntity.latitude = location.latitude;
        dbEntity.longitude = location.longitude;
        dbEntity.weatherCode = location.weatherCode;
        
        [self.managedObjectContext save:nil];
    }
}


- (void)deleteLocationFromDatabaseWithLatitude:(double)latitude longitude:(double)longitude {
    NSArray *recentSearches = [self fetchLocations];
    NSInteger indexOfObjectInDatabase = [self indexOfObjectInDatabaseLatitude:latitude
                                                                    longitude:longitude
                                                            isCurrentLocation:NO];
    if (indexOfObjectInDatabase == NSNotFound) {
        return;
    }
    LocationEntity *dbEntity = recentSearches[indexOfObjectInDatabase];
    [self.managedObjectContext deleteObject:dbEntity];
    [self.managedObjectContext save:nil];
}


- (NSArray *)fetchLocations {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[LocationEntity entityName]
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}


- (void)insertGeolocationInDatabse:(WTHLocationEntityModel *)location {
    NSManagedObjectContext *context = [self managedObjectContext];
    LocationEntity *insertQuerry = [NSEntityDescription insertNewObjectForEntityForName:[LocationEntity entityName]
                                                                 inManagedObjectContext:context];
    insertQuerry.address = location.address;
    insertQuerry.longitude = location.longitude;
    insertQuerry.latitude = location.latitude;
    insertQuerry.weatherDescription = location.weatherDescription;
    insertQuerry.temperatureValueC = location.temperatureValueC;
    insertQuerry.temperatureValueF = location.temperatureValueF;
    insertQuerry.isCurrentLocation = location.isCurrentLocation;
    insertQuerry.weatherCode = location.weatherCode;
    
    [context save:nil];
}


- (NSInteger)indexOfObjectInDatabaseLatitude:(double)latitude longitude:(double)longitude isCurrentLocation:(BOOL)isCurrentLocation {
    NSArray *recentSearches = [self fetchLocations];
    return [recentSearches indexOfObjectPassingTest:^BOOL(LocationEntity *entity, NSUInteger idx, BOOL *stop) {
        return (entity.latitude == latitude && entity.longitude == longitude) || (entity.isCurrentLocation && isCurrentLocation);
    }];
}

@end
