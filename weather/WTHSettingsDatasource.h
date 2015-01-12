//
//  WTHSettingsDatasource.h
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHSettingsCellModel.h"

@interface WTHSettingsDatasource : NSObject

- (NSString *)titleForHeader;
- (NSInteger)numberOfRows;
- (WTHSettingsCellModel *)cellModelForRow:(NSInteger)row;
- (void)changeValueForRow:(NSInteger)row;

@end
