//
//  NSDictionary+SafeObjects.m
//  weather
//
//  Created by Andrei Vidrasco on 1/14/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NSDictionary+SafeObjects.h"

@implementation NSDictionary (SafeObjects)

- (id)safeObjectForKey:(id)aKey {
    id object = self[aKey];
    if ((NSNull *)object == [NSNull null]) return nil;
    
    return object;
}

@end
