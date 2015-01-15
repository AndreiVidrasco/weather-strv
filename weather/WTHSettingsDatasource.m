//
//  WTHSettingsDatasource.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSettingsDatasource.h"
#import "WTHSettingsHandler.h"

typedef NS_ENUM (NSInteger, RowIndexes) {
    RowIndexesMetric,
    RowIndexesTemperature,
};

@interface WTHSettingsDatasource ()

@property (strong, nonatomic) NSArray *datasource;

@end

@implementation WTHSettingsDatasource

- (NSArray *)datasource {
    if (!_datasource) {
        WTHSettingsCellModel *firstCellModel = [[WTHSettingsCellModel alloc] initWithMainTitle:NSLocalizedString(@"Unit of length", nil)];
        WTHSettingsCellModel *secondeCellModel = [[WTHSettingsCellModel alloc] initWithMainTitle:NSLocalizedString(@"Unit of temperature", nil)];
        _datasource = @[firstCellModel, secondeCellModel];
    }

    return _datasource;
}


- (NSString *)titleForHeader {
    return NSLocalizedString(@"General", nil);
}


- (NSInteger)numberOfRows {
    return [self.datasource count];
}


- (WTHSettingsCellModel *)cellModelForRow:(NSInteger)row {
    [self updateInformation];
    return self.datasource[row];
}


- (void)changeValueForRow:(NSInteger)row {
    switch (row) {
        case RowIndexesMetric:
            [self changeMetricToOposite];
            break;
        case RowIndexesTemperature:
            [self changeTemperatureToOposite];
        default:
            break;
    }
}


- (void)updateInformation {
    MetricUnit metricUnit = [[WTHSettingsHandler sharedHandler] currentMetricUnit];
    [self changeDetailValueForModelWithIndex:RowIndexesMetric newValue:[self stringForMetricUnit:metricUnit]];
    TemperatureUnit tempUnit = [[WTHSettingsHandler sharedHandler] currentTemperatureUnit];
    [self changeDetailValueForModelWithIndex:RowIndexesTemperature newValue:[self stringForTemperatureUnit:tempUnit]];
}


- (void)changeTemperatureToOposite {
    TemperatureUnit unit = [[WTHSettingsHandler sharedHandler] currentTemperatureUnit];
    [WTHSettingsHandler sharedHandler].currentTemperatureUnit = !unit;
}


- (void)changeMetricToOposite {
    MetricUnit unit = [[WTHSettingsHandler sharedHandler] currentMetricUnit];
    [WTHSettingsHandler sharedHandler].currentMetricUnit = !unit;
}


- (void)changeDetailValueForModelWithIndex:(NSInteger)index newValue:(NSString *)value {
    WTHSettingsCellModel *cellModel = self.datasource[index];
    cellModel.detailTitle = value;
}


- (NSString *)stringForTemperatureUnit:(TemperatureUnit)unit {
    switch (unit) {
        case TemperatureUnitFahrenheit:
            return NSLocalizedString(@"Fahrenheit", nil);
            break;
        case TemperatureUnitCelsius:
            return NSLocalizedString(@"Celsius", nil);
            break;
        default:
            return @"";
            break;
    }
}


- (NSString *)stringForMetricUnit:(MetricUnit)unit {
    switch (unit) {
        case MetricUnitMiles:
            return NSLocalizedString(@"Miles", nil);
            break;
        case MetricUnitMeters:
            return NSLocalizedString(@"Meters", nil);
            break;
        default:
            return @"";
            break;
    }
}

@end
