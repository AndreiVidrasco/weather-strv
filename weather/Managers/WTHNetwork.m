//
//  MSRNetwork.m
//  myshows
//
//  Created by Andrei Vidrasco on 10/4/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "WTHNetwork.h"
#import <AFHTTPSessionManager.h>
#import "WTHCurrentLocationInformation.h"
#import "WTHGeoLocation.h"
#import "WTHLocationsStorageManager.h"

#define BaseURL @"http://api.worldweatheronline.com/free/v2/"

@interface WTHNetwork ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation WTHNetwork

+ (instancetype)sharedManager {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });

    return sharedMyManager;
}


- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager) {
        return _sessionManager;
    }

    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]
                                               sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                                 @"text/javascript",
                                                                 @"application/json",
                                                                 @"text/json", nil];

    return _sessionManager;
}


- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDictionary *updatedParams = [self addDefaultParametersToDictionary:parameters];
    [self.sessionManager GET:URLString parameters:updatedParams success:^(NSURLSessionDataTask *task, id responseObject) {
         success(task, responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(task, error);
     }];
}


- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success {
    [self GET:URLString parameters:parameters success:success failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:underlyingError.localizedDescription
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}


- (void)makeRequestWithLocation:(CLLocationCoordinate2D)location
                        success:(void (^)(id responseObject))success {
    NSString *querry = [NSString stringWithFormat:@"%.3f,%.3f", location.latitude, location.longitude];
    [self makeRequestWithQuerry:querry success:success];
}


- (void)makeRequestWithQuerry:(NSString *)querry
                        success:(void (^)(id responseObject))success {
    NSDictionary *parameters = @{@"q" : querry,
                                 @"num_of_days" : @"10",
                                 @"includeLocation" : @"yes",
                                 @"tp" : @"24",
                                 @"date" : @"today"};
    [[WTHNetwork sharedManager] GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    }];
}

- (NSDictionary *)addDefaultParametersToDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    mutableDictionary[@"key"] = @"a1f20b7a42903cced352abb361b05";
    mutableDictionary[@"format"] = @"json";

    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}


@end
