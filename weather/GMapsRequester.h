//
//  GMapsAutocompleter.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

@import CoreLocation;
@class GeoLocation;

@interface GMapsRequester : NSObject

+ (instancetype)sharedManager;

- (void)geocodeString:(NSString *)query
      completionBlock:(void (^)(GeoLocation *geoLocation))completionBlock;

- (void)autcompleteForSearchString:(NSString *)query
                   completionBlock:(void (^)(NSArray *))suggestionsReady;

@end