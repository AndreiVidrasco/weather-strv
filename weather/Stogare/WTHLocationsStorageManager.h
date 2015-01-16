//
//  WTHLocationsManager.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHStorageManager.h"
#import "WTHLocationEntityModel.h"

@interface WTHLocationsStorageManager : WTHStorageManager

- (void)insertLocationIntoDatabaseIfNew:(WTHLocationEntityModel *)location;
- (void)deleteLocationFromDatabaseWithLatitude:(double)latitude longitude:(double)longitude;

@property (nonatomic, readonly) NSArray *fetchLocations;

@end
