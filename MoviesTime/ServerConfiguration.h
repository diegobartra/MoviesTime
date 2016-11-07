//
//  ServerConfiguration.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLoadingManager.h"

extern NSString * const BackdropImageSizeSmall;
extern NSString * const BackdropImageSizeMedium;
extern NSString * const BackdropImageSizeLarge;
extern NSString * const BackdropImageSizeOriginal;
extern NSString * const PosterImageSizeSmall;
extern NSString * const PosterImageSizeMedium;
extern NSString * const PosterImageSizeLarge;
extern NSString * const PosterImageSizeOriginal;

@interface ServerConfiguration : NSObject <DataLoading>

@property (nonatomic, readonly) NSString *imageBaseURL;
@property (nonatomic, readonly) NSString *imageSecureBaseURL;

+ (ServerConfiguration *)defaultConfiguration;
- (void)fetch;
- (NSURL *)imageURLWithSize:(NSString *)size path:(NSString *)path;

@end
