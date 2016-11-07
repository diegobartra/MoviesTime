//
//  BasicDataSource.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "DataSource.h"

@interface BasicDataSource : DataSource

@property (nonatomic, copy) NSArray *items;

- (void)insertItem:(id)item;
- (void)insertItems:(NSArray *)items;

- (void)insertItem:(id)item atIndex:(NSUInteger)index;
- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;

@end
