//
//  WTHForecastDatasource.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastDatasource.h"

@implementation WTHForecastDatasource

- (NSInteger)numberOfRows {
    return 0;  //implemented by child
}


- (WTHForecastCellModel *)cellModelForRow:(NSInteger)row {
    return nil; //implemented by child
}

@end
