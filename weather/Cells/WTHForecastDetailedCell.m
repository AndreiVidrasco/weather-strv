//
//  WTHForecastDetailedCell.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHForecastDetailedCell.h"

@interface WTHForecastDetailedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *forecastImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currenLocationIcon;

@end

@implementation WTHForecastDetailedCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self scanSubviews];
    }
}


- (void)dealloc {
    [self.contentView removeObserver:self forKeyPath:@"frame"];
}


- (void)updateWithCellModel:(WTHForecastCellModel *)cellModel {
    self.forecastImage.image = [UIImage imageNamed:cellModel.imageName];
    self.temperatureLabel.text = cellModel.temperatureValue;
    self.cityLabel.text = cellModel.mainTitle;
    self.weatherLabel.text = cellModel.detailTitle;
    self.currenLocationIcon.hidden = !cellModel.showCurrentLocationIcon;
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


- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) return;
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        [self scanSubviewsIOS7];
        [self performSelector:@selector(scanSubviewsIOS7) withObject:nil afterDelay:0];
    }
}


- (void)changeConfimationButtonStyle:(UIView *)view {
    UIButton *button = (UIButton *)view;
    [button setBackgroundImage:[UIImage imageNamed:@"location_delete"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"location_delete_icon"] forState:UIControlStateNormal];
    for (UILabel *subviews in button.subviews) {
        if ([subviews isKindOfClass:[UILabel class]]) {
            subviews.text = @"";
        }
    }
    [button setTitle:@"" forState:UIControlStateNormal];
}


- (void)scanSubviews {
    NSArray *subviews = self.subviews;
    for (UIView *view in subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            for (UIView *subview in view.subviews) {
                if ([NSStringFromClass([subview class]) isEqualToString:@"_UITableViewCellActionButton"]) {
                    [self changeConfimationButtonStyle:subview];
                }
            }
        }
    }
}


- (void)scanSubviewsIOS7 {
    NSArray *subviews = self.subviews;
    for (UIView *view in subviews) {
        for (UIView *subview in view.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                for (UIView *subSubview in subview.subviews) {
                    if ([NSStringFromClass([subSubview class]) isEqualToString:@"UITableViewCellDeleteConfirmationButton"]) {
                        [self changeConfimationButtonStyle:subSubview];
                    }
                }
            }
        }
    }
}

@end
