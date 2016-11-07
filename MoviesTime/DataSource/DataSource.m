//
//  DataSource.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "DataSource.h"
#import "PlaceholderView.h"

@interface DataSource ()

@property (nonatomic, weak) Loading *loadingInstance;
@property (nonatomic, strong) TablePlaceholderView *placeholderView;

@end

CGFloat const LoadingPlaceholderHeight = 80;

@implementation DataSource

@synthesize loadingState = _loadingState;
@synthesize loadingError = _loadingError;

- (instancetype)init {

    self = [super init];
    
    if (self) {
        _loadingState = LoadStateInitial;
    }
    
    return self;
}

- (CGFloat)headerViewHeight {

    return 0;
}

#pragma mark - Content loading methods

- (NSString *)loadingState {

    if (!_loadingState) {
        _loadingState = LoadStateInitial;
    }
    
    return _loadingState;
}

- (void)resetContent {

    self.loadingInstance.current = NO;
    self.loadingState = LoadStateInitial;
}

- (void)beginLoading {

    self.loadingComplete = NO;
    
    if ([self.loadingState isEqualToString:LoadStateError])
        [self resetContent];
    
    self.loadingState = (([self.loadingState isEqualToString:LoadStateInitial] || [self.loadingState isEqualToString:LoadStateLoadingContent] || [self.loadingState isEqualToString:LoadStateError])? LoadStateLoadingContent : LoadStateRefreshingContent);
    
    if ([self.loadingState isEqualToString:LoadStateLoadingContent])
        [self notifyForTableViewScrollEnabled:NO];
    
    [self notifyWillLoadContent];
}

- (void)endLoadingWithState:(NSString *)state error:(NSError *)error update:(dispatch_block_t)update {

    NSUInteger numberOfSections = self.numberOfSections;
    
    self.loadingState = state;
    self.loadingError = error;
    
    if (update)
        update();
    
    if ([state isEqualToString:LoadStateContentLoaded]) {
        [self notifyForTableViewScrollEnabled:YES];
        
    } else if ([state isEqualToString:LoadStateNoContent]) {
        [self notifyForTableViewScrollEnabled:NO];
        
    } else if ([state isEqualToString:LoadStateError]) {
        
        if (error) {
            self.errorTitle = error.localizedDescription;
            self.errorMessage = error.localizedFailureReason;
        }
        
        NSIndexSet *removedSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfSections)];
        NSIndexSet *insertedSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSections)];
        
        [self notifyBatchUpdate:^{
            [self notifySectionsRemoved:removedSet];
            [self notifySectionsInserted:insertedSet];
        }];
        
        [self notifyForTableViewScrollEnabled:NO];
    }
    
    self.loadingComplete = YES;
    [self notifyDidLoadContentWithError:error];
}

- (void)setNeedsLoadContent {

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadContent) object:nil];
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0];
}

- (void)loadContentWithBlock:(LoadingBlock)block {

    [self beginLoading];
    
    __weak DataSource *weakSelf = self;
    
    Loading *loading = [Loading loadingWithCompletionHandler:^(NSString *newState, NSError *error, LoadingUpdateBlock update) {
        
        if (!newState)
            return;
        
        [self endLoadingWithState:newState error:error update:^{
            
            DataSource *me = weakSelf;
            if (update && me)
                update(me);
        }];
        
    }];
    
    self.loadingInstance.current = NO;
    self.loadingInstance = loading;
    
    block(loading);
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView {

    [tableView registerClass:[TablePlaceholderView class] forHeaderFooterViewReuseIdentifier:@"TablePlaceholderView"];
}

- (UIView *)placeholderViewHeaderForTableView:(UITableView *)tableView inSection:(NSInteger)section {

    if (self.shouldDisplayPlaceholder) {
        return [self dequeuePlaceholderViewForTableView:tableView inSection:section];
    }
    
    return nil;
}

- (TablePlaceholderView *)dequeuePlaceholderViewForTableView:(UITableView *)tableView inSection:(NSInteger)section {

    _placeholderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TablePlaceholderView"];
    _placeholderView.contentView.backgroundColor = [UIColor whiteColor];
    [self updatePlaceholder:_placeholderView];
    
    return _placeholderView;
}

- (CGFloat)hightForPlaceholderViewForTableView:(UITableView *)tableView
                          verticalSpaceCovered:(CGFloat)spaceCovered
                                     inSection:(NSInteger)section {

    if ([self.loadingState isEqualToString:LoadStateLoadingContent])
        return LoadingPlaceholderHeight;
    else
        return tableView.bounds.size.height-spaceCovered;
}

- (CGFloat)hightForHeaderViewForTableView:(UITableView *)tableView
                     verticalSpaceCovered:(CGFloat)spaceCovered
                                inSection:(NSInteger)section {

    if (self.shouldDisplayPlaceholder) {
        return [self hightForPlaceholderViewForTableView:tableView verticalSpaceCovered:spaceCovered inSection:section];
    }
    
    return self.headerViewHeight;
}

- (void)updatePlaceholder:(TablePlaceholderView *)placeholderView {

    if (placeholderView) {
        NSString *loadingState = self.loadingState;
        
        if ([loadingState isEqualToString:LoadStateLoadingContent])
            [placeholderView showActivityIndicator:YES];
        else
            [placeholderView showActivityIndicator:NO];
        
        if ([loadingState isEqualToString:LoadStateNoContent]) {
            [placeholderView showPlaceholderViewWithTitle:self.noContentTitle
                                                  message:self.noContentMessage
                                              buttonTitle:self.noContentButtonTitle
                                             buttonAction:self.noContentButtonAction
                                                 animated:YES];
            
        } else if ([loadingState isEqualToString:LoadStateError]) {
            [placeholderView showPlaceholderViewWithTitle:self.errorTitle
                                                  message:self.errorMessage
                                              buttonTitle:self.errorButtonTitle
                                             buttonAction:self.errorButtonAction
                                                 animated:YES];
            
        } else {
            [placeholderView hidePlaceholderViewAnimated:YES];
        }
    }
}

- (BOOL)shouldDisplayPlaceholder {

    NSString *loadingState = [self loadingState];
    
    if (([loadingState isEqualToString:LoadStateLoadingContent]) || ([loadingState isEqualToString:LoadStateNoContent]) || ([loadingState isEqualToString:LoadStateError])) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Subclass methods

- (NSInteger)numberOfSections {

    return 1;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

- (NSIndexPath *)indexPathForItem:(id)item {

    return nil;
}

- (void)loadContent {
    
}

#pragma mark - Notification methods

- (void)notifyDidReloadData {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSourceDidReloadData:)]) {
        [delegate dataSourceDidReloadData:self];
    }
}

- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didInsertItemsAtIndexPaths:)]) {
        [delegate dataSource:self didInsertItemsAtIndexPaths:insertedIndexPaths];
    }
}

- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRemoveItemsAtIndexPaths:)]) {
        [delegate dataSource:self didRemoveItemsAtIndexPaths:removedIndexPaths];
    }
}

- (void)notifySectionsRefreshed:(NSIndexSet *)sections {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRefreshSections:)]) {
        [delegate dataSource:self didRefreshSections:sections];
    }
}

- (void)notifySectionsInserted:(NSIndexSet *)sections {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didInsertSections:)]) {
        [delegate dataSource:self didInsertSections:sections];
    }
}

- (void)notifySectionsRemoved:(NSIndexSet *)sections {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didRemoveSections:)]) {
        [delegate dataSource:self didRemoveSections:sections];
    }
}

- (void)notifyBatchUpdate:(dispatch_block_t)update {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:performBatchUpdate:)]) {
        [delegate dataSource:self performBatchUpdate:update];
    }
}

- (void)notifyWillLoadContent {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSourceWillLoadContent:)]) {
        [delegate dataSourceWillLoadContent:self];
    }
}

- (void)notifyDidLoadContentWithError:(NSError *)error {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:didLoadContentWithError:)]) {
        [delegate dataSource:self didLoadContentWithError:error];
    }
}

- (void)notifyForTableViewScrollEnabled:(BOOL)enable {

    id<DataSourceDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dataSource:needsTableViewScrollEnabled:)]) {
        [delegate dataSource:self needsTableViewScrollEnabled:enable];
    }
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

@end
