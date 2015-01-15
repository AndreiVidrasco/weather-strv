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

- (NSArray *)recentSearchesArray {
    NSArray *recentSearches = [[WTHLocationsStorageManager sharedManager] fetchLocations];
    if (recentSearches && ([recentSearches count] <= 0)) return nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (LocationEntity *entity in recentSearches) {
        WTHForecastCellModel *cellModel = [[WTHForecastCellModel alloc] init];
        cellModel.mainTitle = entity.address;
        [array addObject:cellModel];
    }
    
    return [[array reverseObjectEnumerator] allObjects];
}

@end
