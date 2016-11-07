//
//  BasicDataSource.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "BasicDataSource.h"

@implementation BasicDataSource

- (void)resetContent {
    
    [super resetContent];
    _items = nil;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger itemIndex = indexPath.row;
    if (itemIndex < [_items count])
        return _items[itemIndex];
    
    return nil;
}

- (NSIndexPath *)indexPathForItem:(id)item {

    NSUInteger index = [_items indexOfObjectIdenticalTo:item];
    
    if (index != NSNotFound)
        return [NSIndexPath indexPathForRow:index inSection:0];
    else
        return nil;
}

- (void)setItems:(NSArray *)items {

    if (_items == items || [_items isEqualToArray:items])
        return;
    
    _items = [items copy];
    
    [self updateLoadingStateFromItems];
    [self notifySectionsRefreshed:[NSIndexSet indexSetWithIndex:0]];
}

- (void)updateLoadingStateFromItems {

    NSString *loadingState = self.loadingState;
    NSUInteger numberOfItems = [_items count];
    
    if (numberOfItems && [loadingState isEqualToString:LoadStateNoContent]) {
        self.loadingState = LoadStateContentLoaded;
        [self notifyForTableViewScrollEnabled:YES];
        
    } else if (!numberOfItems && [loadingState isEqualToString:LoadStateContentLoaded]) {
        self.loadingState = LoadStateNoContent;
        [self notifyForTableViewScrollEnabled:NO];
    }
}

- (void)insertItem:(id)item {
    
    [self insertItems:@[item]];
}

- (void)insertItems:(NSArray *)items {
    
    NSInteger location = [_items count];
    NSInteger length = [items count];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(location, length)];
    
    [self insertItems:items atIndexes:indexes];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index {

    [self insertItems:@[item] atIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes {

    NSMutableArray *newItems = [_items mutableCopy];
    [newItems insertObjects:items atIndexes:indexes];
    
    _items = newItems;
    
    NSMutableArray *insertedIndexPaths = [NSMutableArray arrayWithCapacity:[indexes count]];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [self updateLoadingStateFromItems];
    [self notifyItemsInsertedAtIndexPaths:insertedIndexPaths];
}

#pragma mark - Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.shouldDisplayPlaceholder)
        return 0;
    
    return [_items count];
}

@end
