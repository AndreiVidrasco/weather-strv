//
//  WTHTodayViewModel.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHTodayViewModel.h"
#import "WTHLocationTrackingManager.h"
#import "WTHNetwork.h"
#import "WTHCurrentLocationInformation.h"
#import "WTHSettingsHandler.h"
#import "WTHImageNameFromWeatherDescription.h"

#define MMToInch(x) x / 25.5

@interface WTHTodayViewModel ()

@property (strong, nonatomic) WTHCurrentLocationInformation *currentInformation;

@end

@implementation WTHTodayViewModel


#warning Refactor This SHIT!!!

#pragma mark - Geters

- (WTHCurrentLocationInformation *)currentInformation {
    return [WTHCurrentLocationInformation sharedInformation];
}

- (NSString *)cityName {
    NSString *string = @"";
    if (self.currentInformation.areaName) {
        string = [string stringByAppendingFormat:@"%@, ", self.currentInformation.areaName];
    }
    if (self.currentInformation.region) {
        string = [string stringByAppendingFormat:@"%@, ", self.currentInformation.region];
    }
    if (self.currentInformation.country) {
        string = [string stringByAppendingFormat:@"%@, ", self.currentInformation.country];
    }
    
    return string;
}


- (NSString *)direction {
    return self.currentInformation.winddir16Point;
}


- (NSString *)humidity {
    return [self.currentInformation.humidity stringByAppendingString:@"%"];
}


- (NSString *)precipitation {
    MetricUnit unit = [[WTHSettingsHandler sharedHandler] currentMetricUnit];
    NSString *value;
    switch (unit) {
        case MetricUnitMeters:
            value = [self.currentInformation.precipMM stringByAppendingString:@" mm"];
            break;
        case MetricUnitMiles: {
            CGFloat prep = [self.currentInformation.precipMM floatValue];
            value = [NSString stringWithFormat:@"%.2f inch", MMToInch(prep)];
            break;
        }
        default:
            break;
    }
    
    return value;
}


- (NSString *)pressure {
    return [self.currentInformation.pressure stringByAppendingString:@"hPa"];
}


- (NSString *)temperature {
    TemperatureUnit unit = [[WTHSettingsHandler sharedHandler] currentTemperatureUnit];
    NSString *value;
    NSString *sign;
    switch (unit) {
        case TemperatureUnitCelsius:
            value = self.currentInformation.temp_C;
            sign = @"C";
            break;
        case TemperatureUnitFahrenheit:
            value = self.currentInformation.temp_F;
            sign = @"F";
            break;
        default:
            break;
    }
    
    return [value stringByAppendingFormat:@"°%@ | %@", sign, self.currentInformation.weatherDesc];
}


- (NSString *)weatherImageName {
    return [WTHImageNameFromWeatherDescription imageNameFromWeather:self.currentInformation.weatherDesc];
}


- (NSString *)windSpeed {
    MetricUnit unit = [[WTHSettingsHandler sharedHandler] currentMetricUnit];
    NSString *value;
    switch (unit) {
        case MetricUnitMeters:
            value = [self.currentInformation.windspeedKmph stringByAppendingString:@" km/h"];
            break;
        case MetricUnitMiles:
            value = [self.currentInformation.windspeedMiles stringByAppendingString:@" mph"];
            break;
        default:
            break;
    }
    
    return value;
}


- (BOOL)shouldShowInformation {
    return self.currentInformation.shouldShowInformation;
}

@end
