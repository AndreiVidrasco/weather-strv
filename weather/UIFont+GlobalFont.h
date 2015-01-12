//
//  UIFont+GlobalFont.h
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (GlobalFont)

+ (UIFont *)globalRegularFontOfSize:(CGFloat)size;
+ (UIFont *)globalBoldFontOfSize:(CGFloat)size;
+ (UIFont *)globalLightFontOfSize:(CGFloat)size;
+ (UIFont *)globalSemiboldFontOfSize:(CGFloat)size;

@end
