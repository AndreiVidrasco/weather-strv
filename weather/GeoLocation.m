//
//  GeoLocation.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "GeoLocation.h"

@interface GeoLocation ()

@property (assign, nonatomic, readwrite) CLLocationCoordinate2D coordinates;

@end

@implementation GeoLocation

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryWithKeys {
    if (!dictionaryWithKeys) return nil;
    self = [self init];

    if (self) {
        self.address = [dictionaryWithKeys safeObjectForKey:@"formatted_address"];
        NSDictionary *location = [[dictionaryWithKeys safeObjectForKey:@"geometry"] safeObjectForKey:@"location"];
        self.latitude = [[location safeObjectForKey:@"lat"] doubleValue];
        self.longitude = [[location safeObjectForKey:@"lng"] doubleValue];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone {
    GeoLocation *geoLocatoion = [[self class] allocWithZone:zone];
    if (geoLocatoion) {
        geoLocatoion.address = [self.address copy];
        geoLocatoion.latitude = self.latitude;
        geoLocatoion.longitude = self.longitude;
    }
    
    return geoLocatoion;
}

@end
