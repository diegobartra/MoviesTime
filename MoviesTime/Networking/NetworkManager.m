//
//  NetworkManager.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "JSONParser.h"

@interface NetworkManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation NetworkManager

+ (instancetype)defaultManager {

    static NetworkManager *defaultManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[NetworkManager alloc] initPrivate];
    });
    
    return defaultManager;
}

- (instancetype)init {

    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NetworkManager defaultManager]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate {

    self = [super init];
    
    if (self) {
        _session = [NSURLSession sharedSession];
    }
    
    return self;
}

- (void)startNetworkRequest:(NSURLRequest *)request completionBlock:(NetworkResponseBlock)block {

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable networkError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NetworkIndicatorController sharedIndicatorController] networkActivityDidEnd];
        });
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = HTTPResponse.statusCode;
        
        NSLog(@"Status Code: %li", (long)statusCode);
        
        NSDictionary *JSON = nil;
        NSError *error = nil;
        
        if (!networkError) {
            
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data:%@", string);
            
            JSON = [JSONParser JSONObjectWithData:data];
            
            if (statusCode != 200) {
                
                NSString *statusMessage = JSON[@"status_message"];
                
                if (statusMessage) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : statusMessage,
                                               NSLocalizedFailureReasonErrorKey : @"",
                                               NSLocalizedRecoverySuggestionErrorKey : @""};
                    
                    error = [NSError errorWithDomain:@"" code:1 userInfo:userInfo];
                }
            }
            
        } else {
            error = networkError;
        }
        
        if (block) {
            block(JSON, HTTPResponse, error);
        }
        
    }];
    
    [task resume];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NetworkIndicatorController sharedIndicatorController] networkActivityDidStart];
    });
}

@end

@interface NetworkIndicatorController ()

@property (nonatomic) NSUInteger activityCount;
@property (nonatomic, strong) Timer *visibilityTimer;

@end

@implementation NetworkIndicatorController

+ (instancetype)sharedIndicatorController {

    static NetworkIndicatorController *sharedIndicatorController = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIndicatorController = [[NetworkIndicatorController alloc] initPrivate];
    });
    
    return sharedIndicatorController;
}

- (instancetype)init {

    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NetworkIndicatorController sharedIndicatorController]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate {

    self = [super init];
    
    if (!self)
        return nil;
    
    _activityCount = 0;
    
    return self;
}

- (void)networkActivityDidStart {

    self.activityCount++;
    
    [self updateIndicatorVisibility];
}

- (void)networkActivityDidEnd {

    self.activityCount--;
    
    [self updateIndicatorVisibility];
}

- (void)updateIndicatorVisibility {

    if (self.activityCount > 0) {
        [self showIndicator];
        
    } else {
        
        self.visibilityTimer = [[Timer alloc] initWithInterval:0.5 handler:^{
            [self hideIndicator];
        }];
        
    }
}

- (void)showIndicator {

    [self.visibilityTimer cancel];
    self.visibilityTimer = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideIndicator {

    [self.visibilityTimer cancel];
    self.visibilityTimer = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end


@interface Timer ()

@property (nonatomic) BOOL isCancelled;

@end

@implementation Timer

- (instancetype)initWithInterval:(NSTimeInterval)interval handler:(dispatch_block_t)handler {

    self = [super init];
    
    if (self) {
        _isCancelled = NO;
        
        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
        dispatch_after(when, dispatch_get_main_queue(), ^{
            
            if (!self.isCancelled) {
                handler();
            }
            
        });
    }
    
    return nil;
}

- (void)cancel {

    self.isCancelled = YES;
}

@end
