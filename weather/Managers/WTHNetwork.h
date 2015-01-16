//
//  MSRNetwork.h
//  myshows
//
//  Created by Andrei Vidrasco on 10/4/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;


@interface WTHNetwork : NSObject

+ (instancetype)sharedManager;

- (void)makeRequestWithLocation:(CLLocationCoordinate2D)location
                        success:(void (^)(id responseObject))success;
- (void)makeRequestWithQuerry:(NSString *)querry
                      success:(void (^)(id responseObject))success;

@end
