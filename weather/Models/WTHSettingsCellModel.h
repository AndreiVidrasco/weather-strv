//
//  WTHSettingsCellModel.h
//  weather
//
//  Created by Andrei Vidrasco on 1/12/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHSettingsCellModel : NSObject

- (instancetype)initWithMainTitle:(NSString *)mainTitle;

@property (strong, nonatomic, readonly) NSString *mainTitle;
@property (strong, nonatomic) NSString *detailTitle;

@end
