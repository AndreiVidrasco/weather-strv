//
//  WTHForecastDatasource.h
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHForecastCellModel.h"

@interface WTHForecastDatasource : NSObject

- (NSInteger)numberOfRows;
- (WTHForecastCellModel *)cellModelForRow:(NSInteger)row;

@end
