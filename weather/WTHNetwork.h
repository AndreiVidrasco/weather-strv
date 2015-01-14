//
//  MSRNetwork.h
//  myshows
//
//  Created by Andrei Vidrasco on 10/4/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHNetwork : NSObject

+ (instancetype)sharedManager;

/**
 GET Request with standart failure (Shows an alertview on the screen)
 @param URLString api endpoint
 @param parameters request parameters
 @param success completion block in case of success
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success;


/**
 GET Request with specific failure
 @param URLString api endpoint
 @param parameters request parameters
 @param success completion block in case of success
 @param failure completion block in case of failure
 */
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
