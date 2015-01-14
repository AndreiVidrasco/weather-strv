//
//  WTHSettingsViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSettingsViewController.h"
#import "WTHSettingsTableViewCell.h"
#import "WTHSettingsDatasource.h"

@interface WTHSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) WTHSettingsDatasource *datasource;

@end

@implementation WTHSettingsViewController

- (WTHSettingsDatasource *)datasource {
    if (!_datasource) {
        _datasource = [[WTHSettingsDatasource alloc] init];
    }
    
    return _datasource;
}


- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UITableViewHeaderFooterView *)view
       forSection:(NSInteger)section {
    [view.textLabel setTextColor:[UIColor blueTextColor]];
    [view.textLabel setFont:[UIFont globalSemiboldFontOfSize:14]];
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [self.datasource titleForHeader];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.datasource numberOfRows];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [WTHSettingsTableViewCell cellIdentifier];
    WTHSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    WTHSettingsCellModel *model = [self.datasource cellModelForRow:indexPath.row];
    cell.mainTitle.text = model.mainTitle;
    cell.detailTitle.text = model.detailTitle;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.datasource changeValueForRow:indexPath.row];
    [tableView reloadData];
}

@end
