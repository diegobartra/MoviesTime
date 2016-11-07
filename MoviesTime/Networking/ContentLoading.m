//
//  ContentLoading.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "ContentLoading.h"

NSString * const LoadStateInitial = @"Initial";
NSString * const LoadStateLoadingContent = @"LoadingState";
NSString * const LoadStateContentLoaded = @"LoadedState";
NSString * const LoadStateNoContent = @"NoContentState";
NSString * const LoadStateError = @"ErrorState";
NSString * const LoadStateRefreshingContent = @"RefreshingState";

@interface Loading ()

@property (nonatomic, copy) void (^block)(NSString *newState, NSError *error, LoadingUpdateBlock update);

@end

@implementation Loading

+ (instancetype)loadingWithCompletionHandler:(void(^)(NSString *newState, NSError *error, LoadingUpdateBlock update))handler {
    
    Loading *loading = [[self alloc] init];
    loading.block = handler;
    loading.current = YES;
    return loading;
}

- (void)doneWithNewState:(NSString *)newState error:(NSError *)error update:(LoadingUpdateBlock)update {

    void (^block)(NSString *state, NSError *error, LoadingUpdateBlock update) = _block;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        block(newState, error, update);
    });
    
    _block = nil;
}

- (void)ignore {

    [self doneWithNewState:nil error:nil update:nil];
}

- (void)done {

    [self doneWithNewState:LoadStateContentLoaded error:nil update:nil];
}

- (void)doneWithError:(NSError *)error {

    [self doneWithNewState:LoadStateError error:error update:nil];
}

- (void)updateWithContent:(LoadingUpdateBlock)update {

    [self doneWithNewState:LoadStateContentLoaded error:nil update:update];
}

- (void)updateWithNoContent:(LoadingUpdateBlock)update {

    [self doneWithNewState:LoadStateNoContent error:nil update:update];
}

@end
