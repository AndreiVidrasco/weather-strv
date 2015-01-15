//
//  GMapsAutocompleter.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHGMapsRequester.h"
#import "AFHTTPSessionManager.h"
#import "WTHGeoLocation.h"

#define BaseURL @"https://maps.googleapis.com/maps/api/"

@interface WTHGMapsRequester ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (nonatomic) BOOL autocompleterLoading;
@property (strong, nonatomic) NSString *autocompleterQueryInQue;
@property (strong, nonatomic) NSString *geocoderQueryInQue;
@property (nonatomic) BOOL geocoderLoading;
@property (strong, nonatomic, readonly) NSString *googleAPIKey;

@end

@implementation WTHGMapsRequester
@synthesize googleAPIKey = _googleAPIKey;

#pragma mark - Life Cycle

+ (instancetype)sharedManager {
    static dispatch_once_t pred;
    static id sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


#pragma mark - Getters

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager) {
        return _sessionManager;
    }
    
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]
                                               sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    return _sessionManager;
}


#pragma mark - Public Methods
- (void)geocodeString:(NSString *)query
      completionBlock:(void (^)(WTHGeoLocation *geoLocation))completionBlock {
    @synchronized(self) {
        if (self.geocoderLoading) {
            self.geocoderQueryInQue = query;
            
            return;
        }
        self.geocoderLoading = YES;
        [self requestGeocodeFor:query completionBlock:completionBlock];
    }
}


- (void)autcompleteForSearchString:(NSString *)query
                   completionBlock:(void (^)(NSArray *))suggestionsReady {
    @synchronized(self) {
        if (self.autocompleterLoading) {
            self.autocompleterQueryInQue = query;
            
            return;
        }
        
        self.autocompleterLoading = YES;
        [self requestSuggestionsFor:query whenReady:suggestionsReady];
    }
}


#pragma mark - Private methods

- (void)requestGeocodeFor:(NSString *)query
          completionBlock:(void (^)(WTHGeoLocation *geoLocation))completionBlock {
    [self.sessionManager GET:@"geocode/json"
                  parameters:@{@"address" : query}
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         [self processGeocodeResponseWithResponseDictionary:responseObject
                                                            completionBlock:completionBlock];
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         @synchronized(self) {
                             self.geocoderLoading = NO;
                         }
                     }];
}


- (void)requestSuggestionsFor:(NSString *)query
                    whenReady:(void (^)(NSArray *))suggestionsReady {
    [self.sessionManager GET:@"place/autocomplete/json"
                  parameters:@{@"input" : query,
                               @"key" : self.googleAPIKey}
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         [self proccesSuggestionResponseWithResponseDictionary:responseObject
                                                                         query:query
                                                              suggestionsReady:suggestionsReady];
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         @synchronized(self) {
                             self.autocompleterLoading = NO;
                         }
                     }];
}


- (void)processGeocodeResponseWithResponseDictionary:(id)responseDictionary
                                     completionBlock:(void (^)(WTHGeoLocation *))completionBlock {
    NSArray *geocodeList = responseDictionary[@"results"];
    WTHGeoLocation *locCoordinates = [[WTHGeoLocation alloc] initWithDictionary:[geocodeList firstObject]];
    
    if (completionBlock) {
        completionBlock(locCoordinates);
    }
    
    @synchronized(self) {
        self.geocoderLoading = NO;
        if (self.geocoderQueryInQue) {
            [self geocodeString:self.geocoderQueryInQue completionBlock:completionBlock];
            self.geocoderQueryInQue = nil;
        }
    }
}


- (void)proccesSuggestionResponseWithResponseDictionary:(id)responseDictionary
                                                  query:(NSString *)query
                                       suggestionsReady:(void (^)(NSArray *))suggestionsReady {
    NSMutableArray *suggestions = [[NSMutableArray alloc] init];
    NSArray *predictions = responseDictionary[@"predictions"];
    
    for (NSDictionary *place in predictions) {
        [suggestions addObject:place[@"description"]];
    }
    
    if ((suggestionsReady) && (!self.autocompleterQueryInQue)) suggestionsReady(suggestions);
    
    @synchronized(self) {
        self.autocompleterLoading = NO;
        if (self.autocompleterQueryInQue) {
            [self autcompleteForSearchString:self.autocompleterQueryInQue completionBlock:suggestionsReady];
            self.autocompleterQueryInQue = nil;
        }
    }
}


- (NSString *)googleAPIKey {
    if (_googleAPIKey) {
        return _googleAPIKey;
    }
    NSDictionary *infoPList = [[NSBundle mainBundle] infoDictionary];
    NSString *googleAPIKey = infoPList[@"GooglePlacesAppID"];
    
    _googleAPIKey = googleAPIKey ? googleAPIKey : @"";
    
    return _googleAPIKey;
}

@end