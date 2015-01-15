//
//  WTHLocationsManager.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHStorageManager.h"
#import "WTHGeoLocation.h"

@interface WTHLocationsStorageManager : WTHStorageManager

- (void)insertLocationIntoDatabaseIfNew:(WTHGeoLocation *)location;
- (void)deleteLocationFromDatabase:(WTHGeoLocation *)location;

@property (nonatomic, readonly) NSArray *fetchLocations;

@end
