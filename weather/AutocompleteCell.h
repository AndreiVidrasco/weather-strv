//
//  AutocompleteCell.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHMainTableViewCell.h"

@interface AutocompleteCell : WTHMainTableViewCell

- (void)updateWithAddress:(NSString *)address query:(NSString *)query;

@end
