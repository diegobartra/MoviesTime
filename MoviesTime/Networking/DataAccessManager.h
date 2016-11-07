//
//  DataAccessManager.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccessManager : NSObject

+ (DataAccessManager *)manager;

- (void)fetchGenresForMoviesWithCompletionBlock:(void(^)(NSDictionary *genres, NSError *error))block;
- (void)fetchUpcomingMoviesInPage:(NSUInteger)page
                  completionBlock:(void(^)(NSUInteger page, NSUInteger numberOfPages, NSArray *movies, NSError *error))block;

@end
