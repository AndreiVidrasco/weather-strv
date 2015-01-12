//
//  MainTabBarController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont globalSemiboldFontOfSize:18]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITableView appearance] setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

@end
