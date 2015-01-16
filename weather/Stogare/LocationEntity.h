//
//  LocationsEntity.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LocationEntity : NSManagedObject

@property (retain, nonatomic) NSString *address;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (retain, nonatomic) NSString *weatherDescription;
@property (retain, nonatomic) NSString *temperatureValueF;
@property (retain, nonatomic) NSString *temperatureValueC;
@property (assign, nonatomic) BOOL isCurrentLocation;

+ (NSString *)entityName;

@end
