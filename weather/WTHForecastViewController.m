//
//  WTHForecastViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastViewController.h"
#import "WTHForecastDetailedCell.h"
#import "WTHForecastDatasource.h"
#import "WTHForecastCellModel.h"

@interface WTHForecastViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) WTHForecastDatasource *datasource;

@end

@implementation WTHForecastViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasource numberOfRows];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTHForecastDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:[WTHForecastDetailedCell cellIdentifier]];
    WTHForecastCellModel *cellModel = [self.datasource cellModelForRow:indexPath.row];
    cell.forecastImage.image = [UIImage imageNamed:cellModel.imageName];
    cell.temperatureLabel.text = cellModel.temperatureValue;
    cell.cityLabel.text = cellModel.mainTitle;
    cell.weatherLabel.text = cellModel.detailTitle;
    
    return cell;
}

@end
