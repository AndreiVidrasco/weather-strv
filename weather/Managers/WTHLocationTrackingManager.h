//
//  LocationTrackingManager.h
//  Weather
//
//  Created by Andrei Vidrasco on 1/13/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

@import CoreLocation;
#import "WTHNetwork.h"

@interface WTHLocationTrackingManager : NSObject

+ (instancetype)sharedInstance;

- (void)startTrackingUser;
- (void)stopTrackingUser;

@end
