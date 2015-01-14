//
//  LocationTrackingManager.m
//  Weather
//
//  Created by Andrei Vidrasco on 1/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHLocationTrackingManager.h"

@interface WTHLocationTrackingManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WTHLocationTrackingManager

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance {
    static WTHLocationTrackingManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });

    return sharedLocationManager;
}


- (void)dealloc {
    self.locationManager = nil;
}


#pragma mark - Public Methods

- (void)startTrackingUserWithDelegate:(id <WTHLocationTrackerDelegate> )delegate {
    self.delegate = delegate;
    [self stopTrackingUser];
    self.locationManager = nil;

    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];
}


- (void)stopTrackingUser {
    [self.locationManager stopUpdatingLocation];
}


- (BOOL)areLocationServicesAvailable {
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        return NO;
    }

    return [CLLocationManager locationServicesEnabled];
}


#pragma mark - Location Manager private methods

- (CLLocationManager *)locationManager {
    if (_locationManager) {
        return _locationManager;
    }

    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 15.;

    return _locationManager;
}


#pragma mark - Location Manager Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self stopTrackingUser];

    if ([self.delegate respondsToSelector:@selector(locationManagerDidUpdateLocations:)]) {
        [self.delegate locationManagerDidUpdateLocations:locations];
    }
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(locationManagerDidFailWithError:)]) {
        [self.delegate locationManagerDidFailWithError:error];
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusAuthorizedAlways) return;
    if ([self areLocationServicesAvailable]) {
        [self.locationManager startUpdatingLocation];
    }
}


@end
