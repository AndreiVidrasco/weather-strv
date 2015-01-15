//
//  SearchQuerryEntity.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSManagedObject.h>

@interface SearchQuerryEntity : NSManagedObject

@property (nonatomic, retain) NSString *searchQueery;

+ (NSString *)entityName;

@end
