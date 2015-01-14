//
//  WTHTodayResponseModel.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHTodayResponseModel.h"

@interface WTHTodayResponseModel ()

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

@end

@implementation WTHTodayResponseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDictionary *data = [dictionary safeObjectForKey:@"data"];
        NSDictionary *currentCondition = [[data safeObjectForKey:@"current_condition"] firstObject];
        [self extractDataFromCurrentCondition:currentCondition];
        NSDictionary *nearestArea = [[data safeObjectForKey:@"nearest_area"] firstObject];
        [self extractDataFromNearestArea:nearestArea];
    }

    return self;
}


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


- (NSString *)firstValueInArrayFromDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    NSArray *array = [dict safeObjectForKey:key];

    return [[array firstObject] safeObjectForKey:@"value"];
}

@end
