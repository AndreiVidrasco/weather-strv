//
//  WTHLocationEntityModel.h
//  weather
//
//  Created by Andrei Vidrasco on 1/16/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface WTHLocationEntityModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) NSString *temperatureValueF;
@property (strong, nonatomic) NSString *temperatureValueC;
@property (assign, nonatomic) BOOL isCurrentLocation;

@end
