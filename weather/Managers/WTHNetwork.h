//
//  MSRNetwork.h
//  myshows
//
//  Created by Andrei Vidrasco on 10/4/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

NSString *const WTHNetworkDidReceiveNewCurrentLocationInformation;

@interface WTHNetwork : NSObject

+ (instancetype)sharedManager;

- (void)makeRequestWithLocation:(CLLocation *)location
andAddToDatabaseAfterReceivingInformation:(BOOL)adding;

@end
