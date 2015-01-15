//
//  SRCSearchInputViewController.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class SRCSearchInputViewController;
@class GeoLocation;

@protocol SearchInputViewControllerDelegate <NSObject>
@optional
- (void)searchInputVC:(SRCSearchInputViewController *)viewController didFinishPickingLocation:(GeoLocation *)location;

@end

@interface SRCSearchInputViewController : UIViewController

+ (instancetype)instantiateWithDelegate:(id <SearchInputViewControllerDelegate> )delegate;

@end
