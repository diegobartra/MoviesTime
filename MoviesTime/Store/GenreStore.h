//
//  GenreStore.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLoadingManager.h"

@class Genre;

@interface GenreStore : NSObject <DataLoading>

+ (instancetype)sharedStore;
- (void)fetchGenres;
- (Genre *)genreForKey:(NSNumber *)key;

@end
