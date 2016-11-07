//
//  NetworkManager.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkResponseBlock)(id dataObject, NSHTTPURLResponse *response, NSError *error);

@interface NetworkManager : NSObject

+ (instancetype)defaultManager;
- (void)startNetworkRequest:(NSURLRequest *)request completionBlock:(NetworkResponseBlock)block;

@end

@interface NetworkIndicatorController : NSObject

+ (instancetype)sharedIndicatorController;
- (void)networkActivityDidStart;
- (void)networkActivityDidEnd;

@end

@interface Timer : NSObject

- (instancetype)initWithInterval:(NSTimeInterval)interval handler:(dispatch_block_t)handler;
- (void)cancel;

@end
