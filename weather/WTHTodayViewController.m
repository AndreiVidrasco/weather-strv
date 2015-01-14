//
//  WTHTodayViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHTodayViewController.h"
#import "WTHTodayViewModel.h"

@interface WTHTodayViewController () <WTHTodayViewModelProtocol>

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

@end

@implementation WTHTodayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel updateValue];
    [self adjustColorsAndFonts];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInformation];
}


#pragma mark - Getters

- (WTHTodayViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WTHTodayViewModel alloc] initWithDelegate:self];
    }

    return _viewModel;
}


#pragma mark - Private Methods

- (void)updateInformation {
#warning make loading indicator
    self.view.hidden = !self.viewModel.shouldShowInformation;
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
    self.humidityLabel.font =
    self.precipitationLabel.font =
    self.pressureLabel.font =
    self.windLabel.font =
    self.directionLabel.font = [UIFont globalSemiboldFontOfSize:15.f];
    self.shareButton.titleLabel.font = [UIFont globalSemiboldFontOfSize:18.f];
    
    self.cityName.textColor = [UIColor grayTextColor];
    self.temperatureLabel.textColor = [UIColor blueTextColor];
    self.humidityLabel.textColor =
    self.precipitationLabel.textColor =
    self.pressureLabel.textColor =
    self.windLabel.textColor =
    self.directionLabel.textColor = [UIColor grayTextColor];
    self.shareButton.tintColor = [UIColor orangeButtonColor];
}

@end
