//
//  JSONParser.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (id)JSONObjectWithData:(NSData *)data {

    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSData *)dataWithJSONObject:(id)JSON {

    return [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
}

@end
