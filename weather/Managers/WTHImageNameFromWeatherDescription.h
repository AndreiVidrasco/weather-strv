//
//  WTHImageNameFromWeatherDescription.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHImageNameFromWeatherDescription : NSObject

+ (NSString *)imageNameFromWeather:(NSInteger)weatherCode
                          bigImage:(BOOL)bigImage;

@end
