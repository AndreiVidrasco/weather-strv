//
//  NSDictionary+SafeObjects.h
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeObjects)

- (id)safeObjectForKey:(id)aKey;

@end
