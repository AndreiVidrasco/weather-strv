//
//  GeoLocation.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

@import CoreLocation;

@interface GeoLocation : NSObject <NSCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryWithKeys;

@property (strong, nonatomic) NSString *address;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@end
