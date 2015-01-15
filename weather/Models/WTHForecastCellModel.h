//
//  WTHForecastCityModel.h
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHForecastCellModel : NSObject

@property (strong, nonatomic) NSString *mainTitle;
@property (strong, nonatomic) NSString *detailTitle;
@property (strong, nonatomic) NSString *temperatureValue;
@property (strong, nonatomic) NSString *imageName;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *temperatureValueF;
@property (strong, nonatomic) NSString *temperatureValueC;

@end
