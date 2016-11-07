//
//  PagingBasicDataSource.m
//  MoviesTime
//
//  Created by Diego Bartra on 11/1/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "PagingBasicDataSource.h"
#import "PlaceholderView.h"

@interface PagingBasicDataSource ()

@end

@implementation PagingBasicDataSource

- (void)resetContent {
    
    [super resetContent];
    self.currentPage = 0;
    self.numberOfPages = 0;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView {
    
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerClass:[PlaceholderCell class] forCellReuseIdentifier:@"PlaceholderCell"];
}

- (void)updatePagingWithCurrentPage:(NSInteger)currentPage numberOfPages:(NSInteger)numberOfPages {
    
    self.currentPage = currentPage;
    self.numberOfPages = numberOfPages;
    
    if (currentPage == numberOfPages) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.items count] inSection:0];
        [self notifyItemsRemovedAtIndexPaths:@[indexPath]];
    }
}

- (PlaceholderCell *)tableView:(UITableView *)tableView placeholderCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaceholderCell *placeholderCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceholderCell" forIndexPath:indexPath];
    [placeholderCell showActivityIndicator:YES];
    
    return placeholderCell;
}

#pragma mark - Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.shouldDisplayPlaceholder)
        return 0;
    
    if (self.currentPage < self.numberOfPages)
        return [self.items count] + 1;
    else
        return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentPage < self.numberOfPages && indexPath.row == [self.items count]) {
        
        if (self.loadingState == LoadStateContentLoaded) {
            [self loadContent];
        }
        
        return [self tableView:tableView placeholderCellForRowAtIndexPath:indexPath];
        
    } else {
        return [self tableView:tableView aCellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Subclass methods

- (UITableViewCell *)tableView:(UITableView *)tableView aCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
