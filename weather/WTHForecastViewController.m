//
//  WTHForecastViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastViewController.h"
#import "WTHForecastDetailedCell.h"
#import "WTHForecastCellModel.h"
#import "WTHLocationsViewController.h"
#import "WTHCurrentLocationInformation.h"
#import "WTHLocationTrackingManager.h"

@interface WTHForecastViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation WTHForecastViewController

- (void)addRefreshControlToTableView {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshControlToTableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)handleRefresh {
    [[WTHLocationTrackingManager sharedInstance] startTrackingUser];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInformation)
                                                 name:WTHNetworkDidReceiveNewCurrentLocationInformation
                                               object:nil];
    [self updateInformation];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)updateInformation {
    self.navigationItem.title = [WTHCurrentLocationInformation sharedInformation].areaName;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}


- (IBAction)location:(id)sender {
    WTHLocationsViewController *viewController = [WTHLocationsViewController instantiateFromStoryboard];
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self.parentViewController presentViewController:modalNav animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WTHCurrentLocationInformation sharedInformation].nextDaysInformation count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTHForecastDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:[WTHForecastDetailedCell cellIdentifier]];
    WTHForecastCellModel *cellModel = [WTHCurrentLocationInformation sharedInformation].nextDaysInformation[indexPath.row];
    [cell updateWithCellModel:cellModel];

    return cell;
}

@end
