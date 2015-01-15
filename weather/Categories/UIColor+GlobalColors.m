//
//  UIColor+GlobalColors.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIColor+GlobalColors.h"

@implementation UIColor (GlobalColors)

+ (UIColor *)orangeButtonColor {
    return [UIColor colorWithRed:1.f
                           green:136.f/255.f
                            blue:71.f/255.f
                           alpha:1.f];
}


+ (UIColor *)grayTextColor {
    return [UIColor colorWithRed:51.f/255.f
                           green:51.f/255.f
                            blue:51.f/255.f
                           alpha:1.f];

}


+ (UIColor *)blueTextColor {
    return [UIColor colorWithRed:47.f/255.f
                           green:145.f/255.f
                            blue:1.f
                           alpha:1.f];
}

@end
