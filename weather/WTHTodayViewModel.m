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
#import "WTHTodayResponseModel.h"
#import "SettingsHandler.h"

#define MMToInch(x) x/25.5

@interface WTHTodayViewModel () <WTHLocationTrackerDelegate>

@property (weak, nonatomic) id<WTHTodayViewModelProtocol> delegate;
@property (strong, nonatomic) WTHTodayResponseModel *responseModel;

@end

@implementation WTHTodayViewModel
@synthesize cityName = _cityName;
@synthesize direction = _direction;
@synthesize humidity = _humidity;
@synthesize precipitation = _precipitation;
@synthesize pressure = _pressure;
@synthesize temperature = _temperature;
@synthesize weatherImageName = _weatherImageName;
@synthesize windSpeed = _windSpeed;
@synthesize shouldShowInformation = _shouldShowInformation;

- (instancetype)initWithDelegate:(id<WTHTodayViewModelProtocol>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}


- (void)updateValue {
    self.responseModel = nil;
    [self.delegate updateInformation];
    [[WTHLocationTrackingManager sharedInstance] startTrackingUserWithDelegate:self];
}


- (void)locationManagerDidUpdateLocations:(NSArray *)locations {
    [self makeRequestWithLocation:[locations lastObject]];
}

- (void)locationManagerDidFailWithError:(NSError *)error {
    
}


- (void)makeRequestWithLocation:(CLLocation *)location {
    NSString *querry = [NSString stringWithFormat:@"%.3f,%.3f", location.coordinate.latitude, location.coordinate.longitude];
    NSDictionary *parameters = @{@"q" : querry,
                                 @"num_of_days" : @"1",
                                 @"includeLocation" : @"yes",
                                 @"fx" : @"no",
                                 @"date" : @"today"};
    __weak WTHTodayViewModel *weakSelf = self;
    [[WTHNetwork sharedManager] GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.responseModel = [[WTHTodayResponseModel alloc] initWithDictionary:responseObject];
        [weakSelf.delegate updateInformation];
    }];
}


- (NSString *)cityName {
    NSString *string = @"";
    if (self.responseModel.areaName) {
        string = [string stringByAppendingFormat:@"%@, ", self.responseModel.areaName];
    }
    if (self.responseModel.region) {
        string = [string stringByAppendingFormat:@"%@, ", self.responseModel.region];
    }
    if (self.responseModel.country) {
        string = [string stringByAppendingFormat:@"%@, ", self.responseModel.country];
    }
    return string;
}


- (NSString *)direction {
    return self.responseModel.winddir16Point;
}


- (NSString *)humidity {
    return [self.responseModel.humidity stringByAppendingString:@"%"];
}


- (NSString *)precipitation {
    MetricUnit unit = [[SettingsHandler sharedHandler] currentMetricUnit];
    NSString *value;
    switch (unit) {
        case MetricUnitMeters:
            value = [self.responseModel.precipMM stringByAppendingString:@" mm"];
            break;
        case MetricUnitMiles: {
            CGFloat prep = [self.responseModel.precipMM floatValue];
            value = [NSString stringWithFormat:@"%.2f inch", MMToInch(prep)];
        }
            break;
            
        default:
            break;
    }
    
    return value;
}


- (NSString *)pressure {
    return [self.responseModel.pressure stringByAppendingString:@"hPa"];
}


- (NSString *)temperature {
    TemperatureUnit unit = [[SettingsHandler sharedHandler] currentTemperatureUnit];
    NSString *value;
    switch (unit) {
        case TemperatureUnitCelsius:
            value = self.responseModel.temp_C;
            break;
        case TemperatureUnitFahrenheit:
            value = self.responseModel.temp_F;
            break;
        default:
            break;
    }
    return [value stringByAppendingFormat:@"° | %@", self.responseModel.weatherDesc];
}


- (NSString *)weatherImageName {
    return self.responseModel.weatherDesc;
}


- (NSString *)windSpeed {
    MetricUnit unit = [[SettingsHandler sharedHandler] currentMetricUnit];
    NSString *value;
    switch (unit) {
        case MetricUnitMeters:
            value = [self.responseModel.windspeedKmph stringByAppendingString:@" km/h"];
            break;
        case MetricUnitMiles:
            value = [self.responseModel.windspeedMiles stringByAppendingString:@" mph"];
            break;
            
        default:
            break;
    }
    
    return value;
}


- (BOOL)shouldShowInformation {
    return self.responseModel;
}

@end
