//
//  GeoLocation.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHGeoLocation.h"

@interface WTHGeoLocation ()

@property (assign, nonatomic, readwrite) CLLocationCoordinate2D coordinates;

@end

@implementation WTHGeoLocation

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryWithKeys {
    if (!dictionaryWithKeys) return nil;
    self = [self init];

    if (self) {
        self.address = [dictionaryWithKeys safeObjectForKey:@"formatted_address"];
        NSDictionary *geometry = [dictionaryWithKeys safeObjectForKey:@"geometry"];
        NSDictionary *location = [geometry safeObjectForKey:@"location"];
        self.latitude = [[location safeObjectForKey:@"lat"] doubleValue];
        self.longitude = [[location safeObjectForKey:@"lng"] doubleValue];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone {
    WTHGeoLocation *geoLocatoion = [[self class] allocWithZone:zone];
    if (geoLocatoion) {
        geoLocatoion.address = [self.address copy];
        geoLocatoion.latitude = self.latitude;
        geoLocatoion.longitude = self.longitude;
    }
    
    return geoLocatoion;
}


- (CLLocationCoordinate2D)coordinates {
    return _coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
