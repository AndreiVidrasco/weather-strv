//
//  SRCFrequentSuggestionsManager.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SRCFrequentSuggestionsManager.h"


static int maxRecentSearches = 20;

@implementation SRCFrequentSuggestionsManager

+ (instancetype)sharedManager {
    static dispatch_once_t pred;
    static id sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Public Methods

- (void)insertQuerryIntoDatabaseIfNew:(NSString *)querry {
    if (!querry) return;
    NSArray *recentSearches = [self fetchRecentSearches];
    NSInteger indexOfObjectInDatabase = [self indexOfObjectInDatabase:querry];
    if (indexOfObjectInDatabase != NSNotFound) {
        SearchQuerryEntity *dbEntity = recentSearches[indexOfObjectInDatabase];
        [self.managedObjectContext deleteObject:dbEntity];
    }

    [self deleteLastObjectFromDatabaseFromArray:recentSearches];
    [self insertSearchStringInDatabse:querry];
}


- (NSArray *)fetchRecentSearches {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[SearchQuerryEntity entityName]
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    return fetchedObjects;
}


#pragma mark - Private Methods

- (void)insertSearchStringInDatabse:(NSString *)searchString {
    NSManagedObjectContext *context = [self managedObjectContext];
    SearchQuerryEntity *insertQuerry = [NSEntityDescription insertNewObjectForEntityForName:[SearchQuerryEntity entityName]
                                                                     inManagedObjectContext:context];
    insertQuerry.searchQueery = searchString;
    [context save:nil];
}


- (void)deleteLastObjectFromDatabaseFromArray:(NSArray *)recentSearches {
    if ([recentSearches lastObject] && [recentSearches count] >= maxRecentSearches) {
        [self.managedObjectContext deleteObject:recentSearches[0]];
    }
}


- (NSInteger)indexOfObjectInDatabase:(NSString *)querry {
    NSArray *recentSearches = [self fetchRecentSearches];
    return [recentSearches indexOfObjectPassingTest:^BOOL(SearchQuerryEntity *entity, NSUInteger idx, BOOL *stop) {
        return [entity.searchQueery isEqualToString:querry];
    }];
}

@end
