//
//  WTHForecastDetailedCell.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastDetailedCell.h"
#import "WTHImageNameFromWeatherDescription.h"

@interface WTHForecastDetailedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *forecastImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end

@implementation WTHForecastDetailedCell

- (void)updateWithCellModel:(WTHForecastCellModel *)cellModel {
    NSString *imageName = [WTHImageNameFromWeatherDescription imageNameFromWeather:cellModel.imageName];
    self.forecastImage.image = [UIImage imageNamed:imageName];
    self.temperatureLabel.text = cellModel.temperatureValue;
    self.cityLabel.text = cellModel.mainTitle;
    self.weatherLabel.text = cellModel.detailTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cityLabel.textColor = [UIColor grayTextColor];
    self.cityLabel.font = [UIFont globalSemiboldFontOfSize:18.f];
    self.weatherLabel.textColor = [UIColor grayTextColor];
    self.weatherLabel.font = [UIFont globalRegularFontOfSize:15.f];
    self.temperatureLabel.textColor = [UIColor blueTextColor];
    self.temperatureLabel.font = [UIFont globalLightFontOfSize:55.f];
}

@end
