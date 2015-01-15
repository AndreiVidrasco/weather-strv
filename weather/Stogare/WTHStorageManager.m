//
//  WTHStorageManager.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHStorageManager.h"

NSString *const dataBaseName = @"DataModel";

@interface WTHStorageManager ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation WTHStorageManager

#pragma mark - Public Methods

+ (instancetype)sharedManager {
    static dispatch_once_t pred;
    static id sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (void)saveContext {
    if (self.managedObjectContext) {
        [self.managedObjectContext save:nil];
    }
}

#pragma mark - Getters

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:dataBaseName withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_storeCoordinator) {
        return _storeCoordinator;
    }
    NSURL *storeURL = [[self documentsDirectory] URLByAppendingPathComponent:[dataBaseName stringByAppendingString:@"sqlite"]];
    
    NSError *error = nil;
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    
    return _storeCoordinator;
}

#pragma mark - Private Methods

- (NSURL *)documentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
