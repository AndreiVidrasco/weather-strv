//
//  WTHSettingsDatasource.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSettingsDatasource.h"
#import "SettingsHandler.h"

typedef NS_ENUM (NSInteger, RowIndexes) {
    RowIndexesMetric,
    RowIndexesTemperature,
};

@interface WTHSettingsDatasource ()

@property (strong, nonatomic) WTHSettingsCellModel *firstCellModel;
@property (strong, nonatomic) WTHSettingsCellModel *secondeCellModel;

@end

@implementation WTHSettingsDatasource
#warning Refactor This SHIT!!!
- (NSString *)titleForHeader {
    return NSLocalizedString(@"General", nil);
}


- (NSInteger)numberOfRows {
    return 2;
}


- (WTHSettingsCellModel *)cellModelForRow:(NSInteger)row {
    return row == RowIndexesMetric ? self.firstCellModel : self.secondeCellModel;
}


- (void)changeValueForRow:(NSInteger)row {
    switch (row) {
        case RowIndexesMetric: {
            [self changeMetricToOposite];
            break;
        }

        case RowIndexesTemperature: {
            [self changeTemperatureToOposite];
        }

        default: {
            break;
        }
    }
}


- (WTHSettingsCellModel *)firstCellModel {
    if (!_firstCellModel) {
        _firstCellModel = [[WTHSettingsCellModel alloc] init];
        _firstCellModel.mainTitle = NSLocalizedString(@"Unit of length", nil);
    }
    MetricUnit unit = [[SettingsHandler sharedHandler] currentMetricUnit];
    switch (unit) {
        case MetricUnitMiles: {
            _firstCellModel.detailTitle = NSLocalizedString(@"Miles", nil);
            break;
        }

        case MetricUnitMeters: {
            _firstCellModel.detailTitle = NSLocalizedString(@"Meters", nil);
            break;
        }

        default: {
            break;
        }
    }

    return _firstCellModel;
}


- (WTHSettingsCellModel *)secondeCellModel {
    if (!_secondeCellModel) {
        _secondeCellModel = [[WTHSettingsCellModel alloc] init];
        _secondeCellModel.mainTitle = NSLocalizedString(@"Unit of temperature", nil);
    }
    TemperatureUnit unit = [[SettingsHandler sharedHandler] currentTemperatureUnit];
    switch (unit) {
        case TemperatureUnitFahrenheit: {
            _secondeCellModel.detailTitle = NSLocalizedString(@"Fahrenheit", nil);
            break;
        }

        case TemperatureUnitCelsius: {
            _secondeCellModel.detailTitle = NSLocalizedString(@"Celsius", nil);
            break;
        }

        default: {
            break;
        }
    }

    return _secondeCellModel;
}


- (void)changeTemperatureToOposite {
    TemperatureUnit unit = [[SettingsHandler sharedHandler] currentTemperatureUnit];
    switch (unit) {
        case TemperatureUnitCelsius: {
            [[SettingsHandler sharedHandler] setTemperatureUnit:TemperatureUnitFahrenheit];
            break;
        }

        case TemperatureUnitFahrenheit: {
            [[SettingsHandler sharedHandler] setTemperatureUnit:TemperatureUnitCelsius];
            break;
        }

        default: {
            break;
        }
    }
}


- (void)changeMetricToOposite {
    MetricUnit unit = [[SettingsHandler sharedHandler] currentMetricUnit];
    switch (unit) {
        case MetricUnitMeters: {
            [[SettingsHandler sharedHandler] setMetricUnit:MetricUnitMiles];
            break;
        }

        case MetricUnitMiles: {
            [[SettingsHandler sharedHandler] setMetricUnit:MetricUnitMeters];
            break;
        }

        default: {
            break;
        }
    }
}


@end
