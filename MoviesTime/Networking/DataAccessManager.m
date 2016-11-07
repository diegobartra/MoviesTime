//
//  DataAccessManager.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "DataAccessManager.h"
#import "NetworkManager.h"
#import "RequestBuilder.h"
#import "Movie.h"
#import "Genre.h"

static NSString *const UpcomingMoviesPath = @"/movie/upcoming";
static NSString *const GenresForMoviesPath = @"/genre/movie/list";

@implementation DataAccessManager

+ (DataAccessManager *)manager {

    static DataAccessManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataAccessManager alloc] initPrivate];
    });
    
    return manager;
}

- (instancetype)init {

    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DataAccessManager manager]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate {

    return [super init];
}

#pragma mark - Movie

- (void)fetchUpcomingMoviesInPage:(NSUInteger)page
                  completionBlock:(void(^)(NSUInteger page, NSUInteger numberOfPages, NSArray *movies, NSError *error))block
{
    NSArray *queryItems = nil;
    
    if (page) {
        NSString *pageString = [NSString stringWithFormat:@"%lu", (unsigned long)page];
        NSURLQueryItem *pageQueryItem = [NSURLQueryItem queryItemWithName:@"page" value:pageString];
        queryItems = @[pageQueryItem];
    }
    
    NSURLRequest *request = [RequestBuilder GET:UpcomingMoviesPath queryItems:queryItems];
    
    [[NetworkManager defaultManager] startNetworkRequest:request completionBlock:^(NSDictionary *JSON, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSUInteger currentPage = [[JSON objectForKey:@"page"] integerValue];
            NSUInteger numberOfPages = [[JSON objectForKey:@"total_pages"] integerValue];
            NSArray *movieDictionaries = JSON[@"results"];
            
            NSMutableArray *mutableMovies = [NSMutableArray array];
            
            for (NSDictionary *movieDictionary in movieDictionaries) {
                Movie *movie = [Movie movieWithDictionaryRepresentation:movieDictionary];
                [mutableMovies addObject:movie];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(currentPage, numberOfPages, [mutableMovies copy], nil);
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(0, 0, nil, error);
            });
        }
        
    }];
}

#pragma mark - Genre

- (void)fetchGenresForMoviesWithCompletionBlock:(void(^)(NSDictionary *genres, NSError *error))block
{
    NSURLRequest *request = [RequestBuilder GET:GenresForMoviesPath queryItems:nil];
    
    [[NetworkManager defaultManager] startNetworkRequest:request completionBlock:^(NSDictionary *JSON, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {

            NSArray *genreDictionaries = JSON[@"genres"];
            
            NSMutableDictionary *mutableGenresDictionary = [NSMutableDictionary dictionaryWithCapacity:
                                                            [genreDictionaries count]];
            
            for (NSDictionary *genreDictionary in genreDictionaries) {
                Genre *genre = [Genre genreWithDictionaryRepresentation:genreDictionary];
                [mutableGenresDictionary setObject:genre forKey:@(genre.uniqueID)];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block([mutableGenresDictionary copy], nil);
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(nil, error);
            });
        }
        
    }];
}

@end
