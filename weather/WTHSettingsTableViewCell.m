//
//  WTHSettingsTableViewCell.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSettingsTableViewCell.h"

@implementation WTHSettingsTableViewCell

- (void)awakeFromNib {
    self.mainTitle.font = [UIFont globalRegularFontOfSize:17];
    self.detailTitle.font = [UIFont globalRegularFontOfSize:17];
    self.mainTitle.textColor = [UIColor grayTextColor];
    self.detailTitle.textColor = [UIColor blueTextColor];
}

@end
