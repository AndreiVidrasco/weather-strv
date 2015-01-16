//
//  WTHTodayResponseModel.h
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
NSString *const WTHNetworkDidReceiveNewCurrentLocationInformation;

@interface WTHCurrentLocationInformation : NSObject
/**
 Shared instance of this class
 */
+ (instancetype)sharedInformation;
/**
 Make Request to Server with location and Update Location info
 */
- (void)updateCurrentLocation:(CLLocationCoordinate2D)location
      isDeviceCurrentLocation:(BOOL)isDeviceCurrentLocation;

@property (strong, nonatomic, readonly) NSString *humidity;
@property (strong, nonatomic, readonly) NSString *precipMM;
@property (strong, nonatomic, readonly) NSString *pressure;
@property (strong, nonatomic, readonly) NSString *temp_C;
@property (strong, nonatomic, readonly) NSString *temp_F;
@property (strong, nonatomic, readonly) NSString *weatherDesc;
@property (strong, nonatomic, readonly) NSString *winddir16Point;
@property (strong, nonatomic, readonly) NSString *windspeedKmph;
@property (strong, nonatomic, readonly) NSString *windspeedMiles;
@property (strong, nonatomic, readonly) NSArray *nextDaysInformation;
@property (strong, nonatomic, readonly) NSString *areaName;
@property (strong, nonatomic, readonly) NSString *cityName;
@property (assign, nonatomic, readonly) BOOL shouldShowCurrentLocationIcon;
@property (assign, nonatomic, readonly) BOOL shouldShowInformation;

@end
