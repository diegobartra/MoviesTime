//
//  Genre.m
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "Genre.h"

@implementation Genre

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation {
    
    self = [super init];
    
    if (self) {
        [self updateWithDictionary:dictionaryRepresentation];
    }
    
    return self;
}

+ (instancetype)genreWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation {
    
    return [[self alloc] initWithDictionaryRepresentation:dictionaryRepresentation];
}

- (void)updateWithDictionary:(NSDictionary *)dictionaryRepresentation {
    
    NSNumber *uniqueID = dictionaryRepresentation[@"id"];
    if (uniqueID && !self.uniqueID)
        self.uniqueID = [uniqueID integerValue];
    
    NSString *name = dictionaryRepresentation[@"name"];
    if (name)
        self.name = name;
}

@end
