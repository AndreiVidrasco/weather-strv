//
//  SearchQuerryEntity.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SearchQuerryEntity.h"

@implementation SearchQuerryEntity

@dynamic searchQueery;

+ (NSString *)entityName {
    return NSStringFromClass([SearchQuerryEntity class]);
}

@end
