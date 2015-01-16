//
//  SettingsHandler.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSettingsHandler.h"

NSString *const TemperatureSettingValue = @"TemperatureSettingValue";
NSString *const MetricSettingValue = @"MetricSettingValue";
NSString *const CurrentLocationSettingValue = @"CurrentLocationSettingValue";

@implementation WTHSettingsHandler

+ (instancetype)sharedHandler {
    static dispatch_once_t once;
    static WTHSettingsHandler *sharedSettingsHandler;
    dispatch_once(&once, ^{
        sharedSettingsHandler = [[[self class] alloc] init];
    });
    
    return sharedSettingsHandler;
}


- (TemperatureUnit)currentTemperatureUnit {
    return [[NSUserDefaults standardUserDefaults] integerForKey:TemperatureSettingValue];
}


- (void)setCurrentTemperatureUnit:(TemperatureUnit)unit {
    [[NSUserDefaults standardUserDefaults] setInteger:unit forKey:TemperatureSettingValue];
}

- (MetricUnit)currentMetricUnit {
    return [[NSUserDefaults standardUserDefaults] integerForKey:MetricSettingValue];
}


- (void)setCurrentMetricUnit:(MetricUnit)unit {
    [[NSUserDefaults standardUserDefaults] setInteger:unit forKey:MetricSettingValue];
}


- (CLLocation *)currentSelectedLocation {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLocationSettingValue];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


- (void)setCurrentSelectedLocation:(CLLocation *)currentSelectedLocation {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentSelectedLocation];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CurrentLocationSettingValue];
}

@end
