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
#import "WTHLocationTrackingManager.h"
#import "WTHSettingsHandler.h"

@interface WTHLocationsViewController () <UITableViewDataSource, UITableViewDelegate, SearchInputViewControllerDelegate>

@property (strong, nonatomic) WTHLocationsDatasource *datasource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *stickyFooterView;

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake([self topLayoutGuide].length,
                                                   0,
                                                   [self bottomLayoutGuide].length + CGRectGetHeight(self.stickyFooterView.frame) + 10,
                                                   0);
    
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    WTHLocationEntityModel *entityModel = [self.datasource entityForForRow:indexPath.row];
    [[WTHLocationsStorageManager sharedManager] deleteLocationFromDatabaseWithLatitude:entityModel.latitude
                                                                             longitude:entityModel.longitude];
    [tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WTHLocationEntityModel *entityModel = [self.datasource entityForForRow:indexPath.row];
    if (entityModel.isCurrentLocation) {
        [[WTHLocationTrackingManager sharedInstance] startTrackingUser];
        [WTHSettingsHandler sharedHandler].currentSelectedLocation = nil;
    } else {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(entityModel.latitude, entityModel.longitude);
        [WTHSettingsHandler sharedHandler].currentSelectedLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [[WTHCurrentLocationInformation sharedInformation] updateCurrentLocation:location
                                                         isDeviceCurrentLocation:entityModel.isCurrentLocation];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)searchInputVC:(WTHSearchInputViewController *)viewController didFinishPickingLocation:(WTHGeoLocation *)location {
    [[WTHNetwork sharedManager] makeRequestWithLocation:location.coordinates success:^(id responseObject) {
        WTHLocationEntityModel *model = [[WTHLocationEntityModel alloc] initWithDictionary:responseObject];
        model.latitude = location.latitude;
        model.longitude = location.longitude;
        model.address = location.address;
        model.isCurrentLocation = NO;
        [[WTHLocationsStorageManager sharedManager] insertLocationIntoDatabaseIfNew:model];
        [self.tableView setContentOffset:CGPointMake(0, -[WTHForecastDetailedCell prefferedHeight] - 20) animated:YES];
        [self.tableView reloadData];
    }];
}
@end
