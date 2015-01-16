//
//  WTHLocationsDatasource.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHForecastCellModel.h"
@import CoreLocation;

@interface WTHLocationsDatasource : NSObject

@property (nonatomic, readonly) NSInteger numberOfRows;
- (WTHForecastCellModel *)cellModelForRow:(NSInteger)row;
- (CLLocationCoordinate2D)locationForRow:(NSInteger)row;

@end
