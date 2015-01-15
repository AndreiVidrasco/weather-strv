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
 Update Values from dict
 */
- (void)updateInformationWithDict:(NSDictionary *)dictionary;
/**
 Make Request to Server with location and Update Location info
 */
- (void)updateCurrentLocation:(CLLocation *)location;

@property (strong, nonatomic, readonly) NSString *humidity;
@property (strong, nonatomic, readonly) NSString *precipMM;
@property (strong, nonatomic, readonly) NSString *pressure;
@property (strong, nonatomic, readonly) NSString *temp_C;
@property (strong, nonatomic, readonly) NSString *temp_F;
@property (strong, nonatomic, readonly) NSString *weatherDesc;
@property (strong, nonatomic, readonly) NSString *winddir16Point;
@property (strong, nonatomic, readonly) NSString *windspeedKmph;
@property (strong, nonatomic, readonly) NSString *windspeedMiles;
@property (strong, nonatomic, readonly) NSString *areaName;
@property (strong, nonatomic, readonly) NSString *country;
@property (strong, nonatomic, readonly) NSString *region;
@property (strong, nonatomic, readonly) NSArray *nextDaysInformation;
@property (assign, nonatomic, readonly) BOOL shouldShowInformation;


@end