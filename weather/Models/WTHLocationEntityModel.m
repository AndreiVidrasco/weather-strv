//
//  WTHLocationEntityModel.m
//  weather
//
//  Created by Andrei Vidrasco on 1/16/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHLocationEntityModel.h"

@implementation WTHLocationEntityModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDictionary *data = [dictionary safeObjectForKey:@"data"];
        NSDictionary *currentCondition = [[data safeObjectForKey:@"current_condition"] firstObject];
        self.temperatureValueC = [[currentCondition safeObjectForKey:@"temp_C"] stringByAppendingString:@"°"];
        self.temperatureValueF = [[currentCondition safeObjectForKey:@"temp_F"] stringByAppendingString:@"°"];
        self.weatherDescription = [self firstValueInArrayFromDictionary:currentCondition forKey:@"weatherDesc"];
        self.weatherCode = [[currentCondition safeObjectForKey:@"weatherCode"] integerValue];
        NSDictionary *nearestArea = [[data safeObjectForKey:@"nearest_area"] firstObject];
        self.address = [self firstValueInArrayFromDictionary:nearestArea forKey:@"region"];
    }
    
    return self;
}


- (NSString *)firstValueInArrayFromDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    NSArray *array = [dict safeObjectForKey:key];
    
    return [[array firstObject] safeObjectForKey:@"value"];
}

@end

