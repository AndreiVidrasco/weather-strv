//
//  SRCFrequentSuggestionsManager.h
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHStorageManager.h"
#import "SearchQuerryEntity.h"

@interface SRCFrequentSuggestionsManager : WTHStorageManager

- (void)insertQuerryIntoDatabaseIfNew:(NSString *)querry;
@property (nonatomic, readonly) NSArray *fetchRecentSearches;

@end
