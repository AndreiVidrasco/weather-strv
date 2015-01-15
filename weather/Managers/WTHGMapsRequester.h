//
//  GMapsAutocompleter.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

@import CoreLocation;
@class WTHGeoLocation;

@interface WTHGMapsRequester : NSObject

+ (instancetype)sharedManager;

- (void)geocodeString:(NSString *)query
      completionBlock:(void (^)(WTHGeoLocation *geoLocation))completionBlock;

- (void)autcompleteForSearchString:(NSString *)query
                   completionBlock:(void (^)(NSArray *))suggestionsReady;

@end