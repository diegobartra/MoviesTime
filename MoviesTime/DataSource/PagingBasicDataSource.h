//
//  PagingBasicDataSource.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/1/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "BasicDataSource.h"

@interface PagingBasicDataSource : BasicDataSource

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;

- (void)updatePagingWithCurrentPage:(NSInteger)currentPage numberOfPages:(NSInteger)numberOfPages;
- (UITableViewCell *)tableView:(UITableView *)tableView aCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
