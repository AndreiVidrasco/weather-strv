//
//  LocationTrackingManager.h
//  Weather
//
//  Created by Andrei Vidrasco on 1/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreLocation/CoreLocation.h>

@protocol WTHLocationTrackerDelegate <NSObject>

- (void)locationManagerDidUpdateLocations:(NSArray *)locations;
- (void)locationManagerDidFailWithError:(NSError *)error;

@end

@interface WTHLocationTrackingManager : NSObject

+ (instancetype)sharedInstance;

- (void)startTrackingUserWithDelegate:(id<WTHLocationTrackerDelegate> )delegate;
- (BOOL)areLocationServicesAvailable;
- (void)stopTrackingUser;
@property (weak, nonatomic) id<WTHLocationTrackerDelegate> delegate;

@end
