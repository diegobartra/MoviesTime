//
//  DataLoadingManager.m
//  MoviesTime
//
//  Created by Diego Bartra on 11/4/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "DataLoadingManager.h"

@interface DataLoadingManager ()

@property (nonatomic, strong) NSMutableArray *subscribers;
@property (nonatomic, copy) dispatch_block_t pendingSuccessBlock;
@property (nonatomic, copy) dispatch_block_t pendingErrorBlock;

@end

static void * const DataLoadingContext = @"DataLoadingContext";

@implementation DataLoadingManager

- (void)dealloc {
    
    for (id<DataLoading> object in self.subscribers) {
        [self removeObjectFromSubscribers:object];
    }
}

+ (DataLoadingManager *)sharedManager {
    
    static DataLoadingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataLoadingManager alloc] initPrivate];
    });
    
    return manager;
}

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DataLoadingManager manager]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _subscribers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)subscribeObject:(id<DataLoading>)object {
    
    [(NSObject *)object addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:DataLoadingContext];
    [self.subscribers addObject:object];
}

- (void)removeObjectFromSubscribers:(id<DataLoading>)object {
    
    [(NSObject *)object removeObserver:self forKeyPath:@"loaded" context:DataLoadingContext];
    [self.subscribers removeObject:object];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (context == DataLoadingContext) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self executePendingBlocks];
        });
    }
}

- (BOOL)verifyIfAllObjectsAreLoaded {
    
    NSInteger totalSubscribers = [self.subscribers count];
    NSInteger totalLoaded = 0;
    
    for (id<DataLoading> object in self.subscribers) {
        
        if ([object isLoaded]) {
            totalLoaded++;
        }
    }
    
    if (totalLoaded == totalSubscribers)
        return YES;
    else
        return NO;
}

- (BOOL)verifyLoadingError {
    
    NSInteger totalError = 0;
    
    for (id<DataLoading> object in self.subscribers) {
        
        if ([object isLoadingError]) {
            totalError++;
        }
    }
    
    if (totalError)
        return YES;
    else
        return NO;
}

- (void)enqueueSuccessBlock:(dispatch_block_t)successBlock errorBlock:(dispatch_block_t)errorBlock {
    
    if (!successBlock)
        return;
    
    dispatch_block_t success;
    dispatch_block_t oldPendingSuccessBlock = self.pendingSuccessBlock;
    
    if (oldPendingSuccessBlock) {
        success = ^{
            oldPendingSuccessBlock();
            successBlock();
        };
    } else {
        success = successBlock;
    }
    
    self.pendingSuccessBlock = success;
    
    dispatch_block_t error;
    dispatch_block_t oldPendingErrorBlock = self.pendingErrorBlock;
    
    if (oldPendingErrorBlock) {
        error = ^{
            oldPendingErrorBlock();
            errorBlock();
        };
    } else {
        error = errorBlock;
    }
    
    self.pendingErrorBlock = error;
    
    [self executePendingBlocks];
}

- (void)executePendingBlocks {
    
    BOOL allLoaded = [self verifyIfAllObjectsAreLoaded];
    
    if (allLoaded) {
        
        BOOL error = [self verifyLoadingError];
        
        if (!error) {
            dispatch_block_t pendingBlock = self.pendingSuccessBlock;
            self.pendingSuccessBlock = nil;
            if (pendingBlock)
                pendingBlock();
            
            
        } else {
            dispatch_block_t pendingBlock = self.pendingErrorBlock;
            self.pendingErrorBlock = nil;
            if (pendingBlock)
                pendingBlock();
        }
    }
}

@end
