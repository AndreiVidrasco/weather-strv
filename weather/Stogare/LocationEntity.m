//
//  LocationsEntity.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "LocationEntity.h"

@implementation LocationEntity

@dynamic address;
@dynamic latitude;
@dynamic longitude;

+ (NSString *)entityName {
    return NSStringFromClass([LocationEntity class]);
}

@end
