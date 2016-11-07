//
//  Movie.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation {
    
    self = [super init];
    
    if (self) {
        [self updateWithDictionary:dictionaryRepresentation];
    }
    
    return self;
}

+ (instancetype)movieWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation {
    
    return [[self alloc] initWithDictionaryRepresentation:dictionaryRepresentation];
}

- (void)updateWithDictionary:(NSDictionary *)dictionaryRepresentation {

    NSNumber *uniqueID = dictionaryRepresentation[@"id"];
    if (uniqueID && !self.uniqueID)
        self.uniqueID = [uniqueID integerValue];
    
    id title = dictionaryRepresentation[@"title"];
    if (title && (title != [NSNull null]))
        self.title = title;
    
    id overview = dictionaryRepresentation[@"overview"];
    if (overview && (overview != [NSNull null]))
        self.overview = overview;
    
    id posterPath = dictionaryRepresentation[@"poster_path"];
    if (posterPath && (posterPath != [NSNull null]))
        self.posterPath = posterPath;
    
    id backdropPath = dictionaryRepresentation[@"backdrop_path"];
    if (backdropPath && (backdropPath != [NSNull null]))
        self.backdropPath = backdropPath;
    
    id originalTitle = dictionaryRepresentation[@"original_title"];
    if (originalTitle && (originalTitle != [NSNull null]))
        self.originalTitle = originalTitle;
    
    id adult = dictionaryRepresentation[@"adult"];
    if (adult && (adult != [NSNull null]))
        self.adult = [adult boolValue];
    
    id releaseDate = dictionaryRepresentation[@"release_date"];
    if (releaseDate && (releaseDate != [NSNull null]))
        self.releaseDate = [[self dateFormatter] dateFromString:releaseDate];
    
    id genreIDs = dictionaryRepresentation[@"genre_ids"];
    if (genreIDs && (genreIDs != [NSNull null]))
        self.genreIDs = genreIDs;
}

- (NSDateFormatter *)dateFormatter {

    return [[self class] dateFormatter];
}

+ (NSDateFormatter *)dateFormatter {

    static NSDateFormatter *sDateFormatter = nil;
    
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        sDateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return sDateFormatter;
}

@end
