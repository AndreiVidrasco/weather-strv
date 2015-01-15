//
//  WTHSettingsCellModel.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSettingsCellModel.h"

@implementation WTHSettingsCellModel

- (instancetype)initWithMainTitle:(NSString *)mainTitle {
    self = [super init];
    if (self) {
        _mainTitle = mainTitle;
    }
    
    return self;
}

@end
