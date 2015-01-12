//
//  SettingsHandler.h
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TemperatureUnit) {
    TemperatureUnitCelsius,
    TemperatureUnitFahrenheit,
};

typedef NS_ENUM(NSInteger, MetricUnit) {
    MetricUnitMeters,
    MetricUnitMiles,
};

@interface SettingsHandler : NSObject

+ (instancetype)sharedHandler;

- (TemperatureUnit)currentTemperatureUnit;
- (void)setTemperatureUnit:(TemperatureUnit)unit;

- (MetricUnit)currentMetricUnit;
- (void)setMetricUnit:(MetricUnit)unit;

@end
