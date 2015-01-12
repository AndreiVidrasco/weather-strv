//
//  UIFont+GlobalFont.m
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "UIFont+GlobalFont.h"

@implementation UIFont (GlobalFont)

+ (UIFont *)globalRegularFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:size];
}

+ (UIFont *)globalBoldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Bold" size:size];
}


+ (UIFont *)globalLightFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Light" size:size];
}


+ (UIFont *)globalSemiboldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:size];
}

@end
