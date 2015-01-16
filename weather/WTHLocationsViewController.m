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
#import "WTHSearchInputViewController.h"
#import "WTHNetwork.h"
#import "WTHGeoLocation.h"
#import "WTHLocationEntityModel.h"
#import "WTHLocationsStorageManager.h"
#import "WTHCurrentLocationInformation.h"

@interface WTHLocationsViewController () <UITableViewDataSource, UITableViewDelegate, SearchInputViewControllerDelegate>

@property (strong, nonatomic) WTHLocationsDatasource *datasource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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


- (IBAction)addLocation:(id)sender {
    WTHSearchInputViewController *inputVCtrl = [WTHSearchInputViewController instantiateWithDelegate:self];
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:inputVCtrl];
    
    [self.parentViewController presentViewController:modalNav animated:YES completion:nil];

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLLocationCoordinate2D coordinate = [self.datasource locationForRow:indexPath.row];
    [[WTHCurrentLocationInformation sharedInformation] updateCurrentLocation:coordinate];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)searchInputVC:(WTHSearchInputViewController *)viewController didFinishPickingLocation:(WTHGeoLocation *)location {
    //start laoding indicator
    [[WTHNetwork sharedManager] makeRequestWithLocation:location.coordinates success:^(id responseObject) {
        WTHLocationEntityModel *model = [[WTHLocationEntityModel alloc] initWithDictionary:responseObject];
        model.latitude = location.latitude;
        model.longitude = location.longitude;
        model.address = location.address;
        [[WTHLocationsStorageManager sharedManager] insertLocationIntoDatabaseIfNew:model];
        [self.tableView reloadData];
    }];
}
@end
