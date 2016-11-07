//
//  GenreStore.m
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "GenreStore.h"
#import "Genre.h"
#import "DataAccessManager.h"

@interface GenreStore () 

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation GenreStore

@synthesize loaded = _loaded;
@synthesize loadingError = _loadingError;

+ (instancetype)sharedStore {

    static GenreStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init {

    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[GenreStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate {

    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (Genre *)genreForKey:(NSNumber *)key {
    
    return self.dictionary[key];
}

- (void)fetchGenres {
    
    self.loaded = NO;
    [[DataAccessManager manager] fetchGenresForMoviesWithCompletionBlock:^(NSDictionary *genres, NSError *error) {

        if (!error) {
            self.dictionary = [genres mutableCopy];
            self.loadingError = NO;
            
        } else {
            self.loadingError = YES;
        }
        
        self.loaded = YES;
    }];
}

@end
