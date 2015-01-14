//
//  WTHTodayViewModel.h
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTHTodayViewModelProtocol <NSObject>

- (void)updateInformation;

@end


@interface WTHTodayViewModel : NSObject

- (instancetype)initWithDelegate:(id<WTHTodayViewModelProtocol>)delegate;
- (void)updateValue;

@property (assign, nonatomic, readonly) BOOL shouldShowInformation;
@property (strong, nonatomic, readonly) NSString *weatherImageName;
@property (strong, nonatomic, readonly) NSString *cityName;
@property (strong, nonatomic, readonly) NSString *temperature;
@property (strong, nonatomic, readonly) NSString *humidity;
@property (strong, nonatomic, readonly) NSString *precipitation;
@property (strong, nonatomic, readonly) NSString *pressure;
@property (strong, nonatomic, readonly) NSString *windSpeed;
@property (strong, nonatomic, readonly) NSString *direction;

@end
