//
//  WTHForecastCityModel.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastCellModel.h"
#import "WTHSettingsHandler.h"
@implementation WTHForecastCellModel

- (NSString *)temperatureValue {
    TemperatureUnit unit = [WTHSettingsHandler sharedHandler].currentTemperatureUnit;
    switch (unit) {
        case TemperatureUnitCelsius:
            return self.temperatureValueC;
            break;
        case TemperatureUnitFahrenheit:
            return self.temperatureValueF;
            break;
        default:
            return @"";
            break;
    }
}


- (NSString *)mainTitle {
    if (_mainTitle) {
        return _mainTitle;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    _mainTitle = [formatter stringFromDate:[self dateValue]];
    
    return _mainTitle;
}


- (NSDate *)dateValue {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [formatter dateFromString:self.date];
    return date;
}



@end
