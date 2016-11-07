//
//  RequestBuilder.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBuilder : NSObject

+ (NSURLRequest *)GET:(NSString *)path;
+ (NSURLRequest *)GET:(NSString *)path queryItems:(NSArray *)queryItems;
+ (NSURLRequest *)POST:(NSString *)path bodyObject:(NSDictionary *)bodyObject;
+ (NSURLRequest *)PUT:(NSString *)path bodyObject:(NSDictionary *)bodyObject;
+ (NSURLRequest *)DELETE:(NSString *)path;

@end
