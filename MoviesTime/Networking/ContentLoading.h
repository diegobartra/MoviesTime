//
//  ContentLoading.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LoadStateInitial;
extern NSString * const LoadStateLoadingContent;
extern NSString * const LoadStateContentLoaded;
extern NSString * const LoadStateNoContent;
extern NSString * const LoadStateError;
extern NSString * const LoadStateRefreshingContent;

typedef void (^LoadingUpdateBlock)(id object);

@interface Loading : NSObject

@property (nonatomic, getter=isCurrent) BOOL current;

+ (instancetype)loadingWithCompletionHandler:(void(^)(NSString *newState, NSError *error, LoadingUpdateBlock update))handler;

- (void)ignore;
- (void)done;
- (void)doneWithError:(NSError *)error;
- (void)updateWithContent:(LoadingUpdateBlock)update;
- (void)updateWithNoContent:(LoadingUpdateBlock)update;

@end

typedef void (^LoadingBlock)(Loading *loading);

@protocol ContentLoading <NSObject>

@property (nonatomic, copy) NSString *loadingState;
@property (nonatomic, strong) NSError *loadingError;

- (void)loadContent;
- (void)resetContent;
- (void)loadContentWithBlock:(LoadingBlock)block;

@end
