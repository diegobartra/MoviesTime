//
//  Genre.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genre : NSObject

@property (nonatomic) NSUInteger uniqueID;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;
+ (instancetype)genreWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;

@end
