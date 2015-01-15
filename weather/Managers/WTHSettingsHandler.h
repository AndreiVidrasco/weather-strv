//
//  SettingsHandler.h
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHGeoLocation.h"

typedef NS_ENUM(NSInteger, TemperatureUnit) {
    TemperatureUnitCelsius,
    TemperatureUnitFahrenheit,
};

typedef NS_ENUM(NSInteger, MetricUnit) {
    MetricUnitMeters,
    MetricUnitMiles,
};

@interface WTHSettingsHandler : NSObject

+ (instancetype)sharedHandler;

@property (nonatomic) TemperatureUnit currentTemperatureUnit;
@property (nonatomic) MetricUnit currentMetricUnit;
@property (strong, nonatomic) WTHGeoLocation *currentSelectedLocation;

@end
