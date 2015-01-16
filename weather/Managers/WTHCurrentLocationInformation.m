//
//  WTHTodayResponseModel.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHCurrentLocationInformation.h"
#import "WTHForecastCellModel.h"
#import "WTHNetwork.h"
#import "WTHLocationEntityModel.h"
#import "WTHLocationsStorageManager.h"

NSString *const WTHNetworkDidReceiveNewCurrentLocationInformation = @"WTHNetworkDidReceiveNewCurrentLocationInformation";

@interface WTHCurrentLocationInformation ()

@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *precipMM;
@property (strong, nonatomic) NSString *pressure;
@property (strong, nonatomic) NSString *temp_C;
@property (strong, nonatomic) NSString *temp_F;
@property (strong, nonatomic) NSString *weatherDesc;
@property (strong, nonatomic) NSString *winddir16Point;
@property (strong, nonatomic) NSString *windspeedKmph;
@property (strong, nonatomic) NSString *windspeedMiles;
@property (strong, nonatomic) NSString *areaName;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSArray *nextDaysInformation;
@property (assign, nonatomic) BOOL shouldShowCurrentLocationIcon;

@end

@implementation WTHCurrentLocationInformation

#pragma mark - Life Cycle

+ (instancetype)sharedInformation {
    static dispatch_once_t pred;
    static id sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


#pragma mark - Public Methods

- (void)updateInformationWithDict:(NSDictionary *)dictionary {
    NSDictionary *data = [dictionary safeObjectForKey:@"data"];
    NSDictionary *currentCondition = [[data safeObjectForKey:@"current_condition"] firstObject];
    [self extractDataFromCurrentCondition:currentCondition];
    NSDictionary *nearestArea = [[data safeObjectForKey:@"nearest_area"] firstObject];
    [self extractDataFromNearestArea:nearestArea];
    NSArray *forecast = [data safeObjectForKey:@"weather"];
    [self extractDataFromForecast:forecast];
}


- (void)updateCurrentLocation:(CLLocationCoordinate2D)location
      isDeviceCurrentLocation:(BOOL)isDeviceCurrentLocation {
    [[WTHNetwork sharedManager] makeRequestWithLocation:location success:^(id responseObject) {
        [self updateInformationWithDict:responseObject];
        WTHLocationEntityModel *locationEntity = [[WTHLocationEntityModel alloc] init];
        locationEntity.longitude = location.longitude;
        locationEntity.latitude = location.latitude;
        locationEntity.address = self.cityName;
        locationEntity.weatherDescription = self.weatherDesc;
        locationEntity.temperatureValueF = [self.temp_F stringByAppendingString:@"°"];
        locationEntity.temperatureValueC = [self.temp_C stringByAppendingString:@"°"];
        locationEntity.isCurrentLocation = isDeviceCurrentLocation;
        self.shouldShowCurrentLocationIcon = isDeviceCurrentLocation;
        [[WTHLocationsStorageManager sharedManager] insertLocationIntoDatabaseIfNew:locationEntity];
        [[NSNotificationCenter defaultCenter] postNotificationName:WTHNetworkDidReceiveNewCurrentLocationInformation object:responseObject];
    }];
    
}

#pragma mark - Private Methods

- (void)extractDataFromCurrentCondition:(NSDictionary *)currentCondition {
    self.humidity = [currentCondition safeObjectForKey:@"humidity"];
    self.precipMM = [currentCondition safeObjectForKey:@"precipMM"];
    self.pressure = [currentCondition safeObjectForKey:@"pressure"];
    self.temp_C = [currentCondition safeObjectForKey:@"temp_C"];
    self.temp_F = [currentCondition safeObjectForKey:@"temp_F"];
    self.winddir16Point = [currentCondition safeObjectForKey:@"winddir16Point"];
    self.windspeedKmph = [currentCondition safeObjectForKey:@"windspeedKmph"];
    self.windspeedMiles = [currentCondition safeObjectForKey:@"windspeedMiles"];
    self.weatherDesc = [self firstValueInArrayFromDictionary:currentCondition forKey:@"weatherDesc"];
}


- (void)extractDataFromNearestArea:(NSDictionary *)nearestArea {
    self.areaName = [self firstValueInArrayFromDictionary:nearestArea forKey:@"areaName"];
    self.country = [self firstValueInArrayFromDictionary:nearestArea forKey:@"country"];
    self.region = [self firstValueInArrayFromDictionary:nearestArea forKey:@"region"];
}


- (void)extractDataFromForecast:(NSArray *)forecast {
    NSMutableArray *nextDays = [NSMutableArray new];
    for (NSDictionary *dict in forecast) {
        WTHForecastCellModel *cellModel = [[WTHForecastCellModel alloc] init];
        cellModel.date = [dict safeObjectForKey:@"date"];
        NSDictionary *hourly = [[dict safeObjectForKey:@"hourly"] firstObject];
        cellModel.temperatureValueC = [[hourly safeObjectForKey:@"tempC"] stringByAppendingString:@"°"];
        cellModel.temperatureValueF = [[hourly safeObjectForKey:@"tempF"] stringByAppendingString:@"°"];
        cellModel.weatherDescription = [self firstValueInArrayFromDictionary:hourly forKey:@"weatherDesc"];
        cellModel.detailTitle = [self firstValueInArrayFromDictionary:hourly forKey:@"weatherDesc"];
        cellModel.showCurrentLocationIcon = NO;
        [nextDays addObject:cellModel];
    }
    
    self.nextDaysInformation = [NSArray arrayWithArray:nextDays];
}


- (NSString *)firstValueInArrayFromDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    if ([dict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSArray *array = [dict safeObjectForKey:key];

    return [[array firstObject] safeObjectForKey:@"value"];
}


- (BOOL)shouldShowInformation {
    return self.weatherDesc;
}


- (NSString *)cityName {
    NSString *string = @"";
    if (self.areaName) {
        string = [string stringByAppendingFormat:@"%@", self.areaName];
    }
    if (self.region) {
        string = [string stringByAppendingFormat:@", %@", self.region];
    }
    if (self.country) {
        string = [string stringByAppendingFormat:@", %@", self.country];
    }
    
    return string;
}


@end
