//
//  ServerConfiguration.m
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "ServerConfiguration.h"
#import "NetworkManager.h"
#import "RequestBuilder.h"

NSString * const BackdropImageSizeSmall = @"w300";
NSString * const BackdropImageSizeMedium = @"w780";
NSString * const BackdropImageSizeLarge = @"w1280";
NSString * const BackdropImageSizeOriginal = @"original";
NSString * const PosterImageSizeSmall = @"w185";
NSString * const PosterImageSizeMedium = @"w342";
NSString * const PosterImageSizeLarge = @"w780";
NSString * const PosterImageSizeOriginal = @"original";

@interface ServerConfiguration ()

@property (nonatomic, strong) NSString *imageBaseURL;
@property (nonatomic, strong) NSString *imageSecureBaseURL;

@end

static NSString *const ConfigurationPath = @"/configuration";

@implementation ServerConfiguration

@synthesize loaded = _loaded;
@synthesize loadingError = _loadingError;

+ (ServerConfiguration *)defaultConfiguration {
    
    static ServerConfiguration *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerConfiguration alloc] initPrivate];
    });
    
    return manager;
}

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ServerConfiguration manager]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate {
    
    return [super init];
}

#pragma mark - Configuration

- (void)fetch {
    
    self.loaded = NO;
    NSURLRequest *request = [RequestBuilder GET:ConfigurationPath queryItems:nil];
    
    [[NetworkManager defaultManager] startNetworkRequest:request completionBlock:^(NSDictionary *JSON, NSHTTPURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSDictionary *imagesConfiguration = JSON[@"images"];
            
            self.imageBaseURL = imagesConfiguration[@"base_url"];
            self.imageSecureBaseURL = imagesConfiguration[@"secure_base_url"];
            self.loadingError = NO;
            
        } else {
            self.loadingError = YES;
        }
        
        self.loaded = YES;
    }];
}

- (NSURL *)imageURLWithSize:(NSString *)size path:(NSString *)path {
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", self.imageSecureBaseURL, size, path];
    return [NSURL URLWithString:URLString];
}

@end
