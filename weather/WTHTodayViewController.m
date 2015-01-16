//
//  WTHTodayViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHTodayViewController.h"
#import "WTHTodayViewModel.h"
#import "WTHSearchInputViewController.h"
#import "WTHGeoLocation.h"
#import "WTHLocationsViewController.h"
#import "WTHLocationTrackingManager.h"
#import "WTHCurrentLocationInformation.h"
#import "WTHSettingsHandler.h"

@interface WTHTodayViewController ()

@property (strong, nonatomic) WTHTodayViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerAlignmentConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *loadinView;
@property (weak, nonatomic) IBOutlet UIView *informationView;

@end

@implementation WTHTodayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleRefresh];
    [self adjustColorsAndFonts];
    [self stopLoadingIndicator];
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

#pragma mark - Getters

- (WTHTodayViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WTHTodayViewModel alloc] init];
    }

    return _viewModel;
}


- (IBAction)share:(id)sender {
    [self startLoadingIndicator];
    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    dispatch_async(queue, ^{
        NSArray *dataToShare = @[[NSString stringWithFormat:@"%@ - %@", self.viewModel.cityName, self.viewModel.temperature]];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoadingIndicator];
            [self presentViewController:activityViewController animated:YES completion:nil];
        });
    });
}


- (IBAction)location:(id)sender {
    WTHLocationsViewController *viewController = [WTHLocationsViewController instantiateFromStoryboard];
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self.parentViewController presentViewController:modalNav animated:YES completion:nil];
}


#pragma mark - Private Methods

- (void)updateInformation {
    if (self.viewModel.shouldShowInformation) {
        [self stopLoadingIndicator];
    } else {
        [self startLoadingIndicator];
    }
    self.currentLocationIcon.hidden = !self.viewModel.shouldShowCurrentLocationIcon;
    self.weatherImage.image = [UIImage imageNamed:self.viewModel.weatherImageName];
    self.cityName.text = self.viewModel.cityName;
    self.temperatureLabel.text = self.viewModel.temperature;
    self.humidityLabel.text = self.viewModel.humidity;
    self.precipitationLabel.text = self.viewModel.precipitation;
    self.pressureLabel.text = self.viewModel.pressure;
    self.windLabel.text = self.viewModel.windSpeed;
    self.directionLabel.text = self.viewModel.direction;
}


- (void)adjustColorsAndFonts {
    self.cityName.font = [UIFont globalSemiboldFontOfSize:18.f];
    self.temperatureLabel.font = [UIFont globalRegularFontOfSize:25.f];
    self.humidityLabel.font = [UIFont globalSemiboldFontOfSize:15.f];
    self.precipitationLabel.font = [UIFont globalSemiboldFontOfSize:15.f];
    self.pressureLabel.font = [UIFont globalSemiboldFontOfSize:15.f];
    self.windLabel.font = [UIFont globalSemiboldFontOfSize:15.f];
    self.directionLabel.font = [UIFont globalSemiboldFontOfSize:15.f];
    self.shareButton.titleLabel.font = [UIFont globalSemiboldFontOfSize:18.f];
    
    self.cityName.textColor = [UIColor grayTextColor];
    self.temperatureLabel.textColor = [UIColor blueTextColor];
    self.humidityLabel.textColor = [UIColor grayTextColor];
    self.precipitationLabel.textColor = [UIColor grayTextColor];
    self.pressureLabel.textColor = [UIColor grayTextColor];
    self.windLabel.textColor = [UIColor grayTextColor];
    self.directionLabel.textColor = [UIColor grayTextColor];
    self.shareButton.tintColor = [UIColor orangeButtonColor];
    if ([UIScreen mainScreen].bounds.size.height < 500) {
        self.centerAlignmentConstraint.constant = 40;
    }
}


- (void)startLoadingIndicator {
    self.informationView.hidden = YES;
    self.loadinView.hidden = NO;
    [self.activityIndicator startAnimating];
}


- (void)stopLoadingIndicator {
    self.informationView.hidden = NO;
    self.loadinView.hidden = YES;
    [self.activityIndicator stopAnimating];
}


- (void)handleRefresh {
    CLLocation *location = [WTHSettingsHandler sharedHandler].currentSelectedLocation;
    if (location) {
        [[WTHCurrentLocationInformation sharedInformation] updateCurrentLocation:location.coordinate
                                                         isDeviceCurrentLocation:NO];
    } else {
        [[WTHLocationTrackingManager sharedInstance] startTrackingUser];
    }
}

@end
