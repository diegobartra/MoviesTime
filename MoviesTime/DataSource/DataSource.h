//
//  DataSource.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentLoading.h"

@class TablePlaceholderView;
@protocol DataSourceDelegate;

@interface DataSource : NSObject <ContentLoading>

@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, readonly) CGFloat headerViewHeight;
@property (nonatomic) BOOL loadingComplete;

- (void)setNeedsLoadContent;

- (void)registerReusableViewsWithTableView:(UITableView *)tableView;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForItem:(id)item;

@property (nonatomic, weak) id<DataSourceDelegate> delegate;

#pragma mark - Placeholders

@property (nonatomic, copy) NSString *noContentTitle;
@property (nonatomic, copy) NSString *noContentMessage;
@property (nonatomic, copy) NSString *noContentButtonTitle;
@property (nonatomic, copy) dispatch_block_t noContentButtonAction;

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *errorTitle;
@property (nonatomic, copy) NSString *errorButtonTitle;
@property (nonatomic, copy) dispatch_block_t errorButtonAction;

- (BOOL)shouldDisplayPlaceholder;

- (UIView *)placeholderViewHeaderForTableView:(UITableView *)tableView inSection:(NSInteger)section;
- (CGFloat)hightForHeaderViewForTableView:(UITableView *)tableView
                     verticalSpaceCovered:(CGFloat)spaceCovered
                                inSection:(NSInteger)section;
- (CGFloat)hightForPlaceholderViewForTableView:(UITableView *)tableView verticalSpaceCovered:(CGFloat)spaceCovered
                                     inSection:(NSInteger)section;
- (TablePlaceholderView *)dequeuePlaceholderViewForTableView:(UITableView *)tableView inSection:(NSInteger)section;

#pragma mark - Notifications

- (void)notifyDidReloadData;
- (void)notifySectionsRefreshed:(NSIndexSet *)sections;

- (void)notifyItemsInsertedAtIndexPaths:(NSArray *)insertedIndexPaths;
- (void)notifyItemsRemovedAtIndexPaths:(NSArray *)removedIndexPaths;
- (void)notifySectionsInserted:(NSIndexSet *)sections;
- (void)notifySectionsRemoved:(NSIndexSet *)sections;

- (void)notifyBatchUpdate:(dispatch_block_t)update;

- (void)notifyWillLoadContent;
- (void)notifyDidLoadContentWithError:(NSError *)error;
- (void)notifyForTableViewScrollEnabled:(BOOL)enable;

@end

@protocol DataSourceDelegate <NSObject>
@optional

- (void)dataSourceDidReloadData:(DataSource *)dataSource;
- (void)dataSource:(DataSource *)dataSource didRefreshSections:(NSIndexSet *)sections;

- (void)dataSource:(DataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)dataSource:(DataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)dataSource:(DataSource *)dataSource didInsertSections:(NSIndexSet *)sections;
- (void)dataSource:(DataSource *)dataSource didRemoveSections:(NSIndexSet *)sections;

- (void)dataSource:(DataSource *)dataSource performBatchUpdate:(dispatch_block_t)update;

- (void)dataSourceWillLoadContent:(DataSource *)dataSource;
- (void)dataSource:(DataSource *)dataSource didLoadContentWithError:(NSError *)error;
- (void)dataSource:(DataSource *)dataSource needsTableViewScrollEnabled:(BOOL)enable;

@end
