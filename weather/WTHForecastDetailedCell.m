//
//  WTHForecastDetailedCell.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastDetailedCell.h"

@implementation WTHForecastDetailedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cityLabel.textColor = [UIColor grayTextColor];
    self.cityLabel.font = [UIFont globalSemiboldFontOfSize:18.f];
    self.weatherLabel.textColor = [UIColor grayTextColor];
    self.weatherLabel.font = [UIFont globalRegularFontOfSize:15.f];
    self.temperatureLabel.textColor = [UIColor blueTextColor];
    self.temperatureLabel.font = [UIFont globalLightFontOfSize:55.f];
}

@end
