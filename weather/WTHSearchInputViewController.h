//
//  SRCSearchInputViewController.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class WTHSearchInputViewController;
@class WTHGeoLocation;

@protocol SearchInputViewControllerDelegate <NSObject>
@optional
- (void)searchInputVC:(WTHSearchInputViewController *)viewController didFinishPickingLocation:(WTHGeoLocation *)location;

@end

@interface WTHSearchInputViewController : UIViewController

+ (instancetype)instantiateWithDelegate:(id <SearchInputViewControllerDelegate> )delegate;

@end
