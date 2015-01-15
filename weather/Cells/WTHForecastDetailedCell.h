//
//  WTHForecastDetailedCell.h
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHMainTableViewCell.h"
#import "WTHForecastCellModel.h"

@interface WTHForecastDetailedCell : WTHMainTableViewCell

- (void)updateWithCellModel:(WTHForecastCellModel *)cellModel;

@end
