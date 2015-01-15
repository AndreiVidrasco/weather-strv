//
//  WTHLocationsViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHLocationsViewController.h"
#import "WTHForecastDetailedCell.h"
#import "WTHForecastCellModel.h"
#import "WTHLocationsDatasource.h"
#import "WTHLocationsStorageManager.h"

@interface WTHLocationsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) WTHLocationsDatasource *datasource;

@end

@implementation WTHLocationsViewController

+ (instancetype)instantiateFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTHLocationsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([WTHLocationsViewController class])];
    
    return viewController;
}


- (WTHLocationsDatasource *)datasource {
    if (!_datasource) {
        _datasource = [[WTHLocationsDatasource alloc] init];
    }
    
    return _datasource;
}


- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTHForecastDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:[WTHForecastDetailedCell cellIdentifier]];
    WTHForecastCellModel *cellModel = [self.datasource cellModelForRow:indexPath.row];
    [cell updateWithCellModel:cellModel];
    
    return cell;
}


@end
