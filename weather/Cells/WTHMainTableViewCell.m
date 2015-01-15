//
//  WTHMainTableViewCell.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHMainTableViewCell.h"

@implementation WTHMainTableViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}


+ (CGFloat)prefferedHeight {
    return 44.f;
}

@end
