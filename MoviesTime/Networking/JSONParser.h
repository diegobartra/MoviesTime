//
//  JSONParser.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (id)JSONObjectWithData:(NSData *)data;
+ (NSData *)dataWithJSONObject:(id)JSON;

@end
