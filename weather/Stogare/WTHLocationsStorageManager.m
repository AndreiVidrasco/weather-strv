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

- (void)insertLocationIntoDatabaseIfNew:(WTHGeoLocation *)location {
    if (!location) return;
    NSArray *recentSearches = [self fetchLocations];
    NSInteger indexOfObjectInDatabase = [self indexOfObjectInDatabase:location.address];
    if (indexOfObjectInDatabase != NSNotFound) {
        LocationEntity *dbEntity = recentSearches[indexOfObjectInDatabase];
        [self.managedObjectContext deleteObject:dbEntity];
    }
    
    [self insertGeolocationInDatabse:location];
}


- (void)deleteLocationFromDatabase:(WTHGeoLocation *)location {
    if (!location) return;
    NSArray *recentSearches = [self fetchLocations];
    NSInteger indexOfObjectInDatabase = [self indexOfObjectInDatabase:location.address];
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


- (void)insertGeolocationInDatabse:(WTHGeoLocation *)location {
    NSManagedObjectContext *context = [self managedObjectContext];
    LocationEntity *insertQuerry = [NSEntityDescription insertNewObjectForEntityForName:[LocationEntity entityName]
                                                                     inManagedObjectContext:context];
    insertQuerry.address = location.address;
    insertQuerry.longitude = location.longitude;
    insertQuerry.latitude = location.latitude;
    
    [context save:nil];
}


- (NSInteger)indexOfObjectInDatabase:(NSString *)address {
    NSArray *recentSearches = [self fetchLocations];
    return [recentSearches indexOfObjectPassingTest:^BOOL(LocationEntity *entity, NSUInteger idx, BOOL *stop) {
        return [entity.address isEqualToString:address];
    }];
}


@end
