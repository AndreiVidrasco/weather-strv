//
//  WTHLocationsDatasource.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHLocationsDatasource.h"
#import "WTHLocationsStorageManager.h"
#import "LocationEntity.h"
#import "WTHForecastCellModel.h"

@interface WTHLocationsDatasource ()

@property (nonatomic, readwrite) NSArray *suggestionsList;

@end

@implementation WTHLocationsDatasource

- (NSArray *)suggestionsList {
    return [self recentSearchesArray];
}

- (NSInteger)numberOfRows {
    return [self.suggestionsList count];
}


- (WTHForecastCellModel *)cellModelForRow:(NSInteger)row {
    return self.suggestionsList[row];
}


- (CLLocationCoordinate2D)locationForRow:(NSInteger)row {
    NSArray *recentSearches = [[WTHLocationsStorageManager sharedManager] fetchLocations];
    LocationEntity *entity = recentSearches[row];
    return CLLocationCoordinate2DMake(entity.latitude, entity.longitude);
}


- (NSArray *)recentSearchesArray {
    NSArray *recentSearches = [[WTHLocationsStorageManager sharedManager] fetchLocations];
    if (recentSearches && ([recentSearches count] <= 0)) return nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (LocationEntity *entity in recentSearches) {
        WTHForecastCellModel *cellModel = [[WTHForecastCellModel alloc] init];
        cellModel.mainTitle = entity.address;
        cellModel.weatherDescription = entity.weatherDescription;
        cellModel.temperatureValueF = entity.temperatureValueF;
        cellModel.temperatureValueC = entity.temperatureValueC;
        
        [array addObject:cellModel];
    }
    
    return [NSArray arrayWithArray:array];
}

@end
