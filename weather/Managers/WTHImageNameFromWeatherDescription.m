//
//  WTHImageNameFromWeatherDescription.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHImageNameFromWeatherDescription.h"

@implementation WTHImageNameFromWeatherDescription

+ (NSString *)imageNameFromWeather:(NSInteger)weatherCode bigImage:(BOOL)bigImage {
    NSString *string = [[NSString alloc] init];
    switch (weatherCode) {
        case 113: //Clear/Sunny
            string = @"location_sun";
            break;
        case 116: //Partly Cloudy
        case 119: //Cloudy
        case 122: //Overcast
        case 143: //Mist
        case 182: //Patchy sleet nearby
        case 185: //Patchy freezing drizzle nearby
        case 227: //Blowing snow
        case 230: //Blizzard
        case 248: //Fog
        case 260: //Freezing fog
            string = @"location_cloudy";
            break;
        case 176: //Patchy rain nearby
        case 179: //Patchy snow nearby
        case 200: //Thundery outbreaks in nearby
        case 263: //Patchy light drizzle
        case 266: //Light drizzle
        case 281: //Freezing drizzle
        case 284: //Heavy freezing drizzle
        case 293: //Patchy light rain
        case 296: //Light rain
        case 299: //Moderate rain at times
        case 302: //Moderate rain
        case 305: //Heavy rain at times
        case 308: //Heavy rain
        case 311: //Light freezing rain
        case 314: //Moderate or Heavy freezing rain
        case 317: //Light sleet
        case 320: //Moderate or heavy sleet
        case 323: //Patchy light snow
        case 326: //Light snow
        case 329: //Patchy moderate snow
        case 332: //Moderate snow
        case 335: //Patchy heavy snow
        case 338: //Heavy snow
        case 350: //Ice pellets
        case 353: //Light rain shower
        case 356: //Moderate or heavy rain shower
        case 359: //Torrential rain shower
        case 362: //Light sleet showers
        case 365: //Moderate or heavy sleet showers
        case 368: //Light snow showers
        case 371: //Moderate or heavy snow showers
        case 374: //Light showers of ice pellets
        case 377: //Moderate or heavy showers of ice pellets
        case 386: //Patchy light rain in area with thunder
        case 389: //Moderate or heavy rain in area with thunder
        case 392: //Patchy light snow in area with thunder
        case 395: //Moderate or heavy snow in area with thunder
            string = @"location_lightning";
            break;
        default:
            string = @"location_wind";
            break;
    }
    if (bigImage) {
        return [string stringByAppendingString:@"_big"];
    } else return string;
}

@end
