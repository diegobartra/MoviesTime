//
//  DataLoadingManager.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/4/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataLoading <NSObject>

@property (nonatomic, getter=isLoaded) BOOL loaded;
@property (nonatomic, getter=isLoadingError) BOOL loadingError;

@end

@interface DataLoadingManager : NSObject

+ (DataLoadingManager *)sharedManager;

- (void)subscribeObject:(id<DataLoading>)object;
- (void)removeObjectFromSubscribers:(id<DataLoading>)object;
- (void)enqueueSuccessBlock:(dispatch_block_t)successBlock errorBlock:(dispatch_block_t)errorBlock;

@end
