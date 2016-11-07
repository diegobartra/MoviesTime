//
//  Movie.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSUInteger uniqueID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *originalTitle;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic) BOOL adult;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic) NSUInteger popularity;
@property (nonatomic, strong) NSArray *genreIDs;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;
+ (instancetype)movieWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;

@end


