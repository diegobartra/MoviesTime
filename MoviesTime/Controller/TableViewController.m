//
//  TableViewController.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (nonatomic) BOOL initialDataSourceSetupDone;
@property (nonatomic, strong) UIColor *separatorColor;

@end

static void * const DataSourceContext = @"DataSourceContext";

@implementation TableViewController

- (void)dealloc {

    [self.tableView removeObserver:self forKeyPath:@"dataSource" context:DataSourceContext];
}

- (void)loadView {

    [super loadView];
    
    [self.tableView addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                        context:DataSourceContext];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (!self.initialDataSourceSetupDone) {
        self.initialDataSourceSetupDone = YES;
        
        UITableView *tableView = self.tableView;
        
        DataSource *dataSource = (DataSource *)tableView.dataSource;
        if ([dataSource isKindOfClass:[DataSource class]]) {
            [dataSource registerReusableViewsWithTableView:tableView];
            [dataSource loadContent];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (DataSourceContext != context) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    UITableView *tableView = object;
    id<UITableViewDataSource> dataSource = tableView.dataSource;
    
    if ([dataSource isKindOfClass:[DataSource class]]) {
        DataSource *cDataSource = (DataSource *)dataSource;
        if (!cDataSource.delegate)
            cDataSource.delegate = self;
    }
}

#pragma mark - Data source delegate methods

- (void)dataSourceDidReloadData:(DataSource *)dataSource {

    [self.tableView reloadData];
}

- (void)dataSource:(DataSource *)dataSource didRefreshSections:(NSIndexSet *)sections {

    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(DataSource *)dataSource didInsertItemsAtIndexPaths:(NSArray *)indexPaths {

    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(DataSource *)dataSource didRemoveItemsAtIndexPaths:(NSArray *)indexPaths {

    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(DataSource *)dataSource didInsertSections:(NSIndexSet *)sections {

    [self.tableView insertSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(DataSource *)dataSource didRemoveSections:(NSIndexSet *)sections {

    [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSource:(DataSource *)dataSource performBatchUpdate:(dispatch_block_t)update {

    [self.tableView beginUpdates];
    update();
    [self.tableView endUpdates];
}

- (void)dataSourceWillLoadContent:(DataSource *)dataSource {
    
}

- (void)dataSource:(DataSource *)dataSource didLoadContentWithError:(NSError *)error {

    UIRefreshControl *refreshControl = self.refreshControl;
    if (refreshControl && refreshControl.isRefreshing) {
        [refreshControl endRefreshing];
    }
}

- (void)dataSource:(DataSource *)dataSource needsTableViewScrollEnabled:(BOOL)enable {

    UITableView *tableView = self.tableView;
    
    if (!enable) {
        
        if (!self.separatorColor) {
            self.separatorColor = tableView.separatorColor;
        }
        
        tableView.separatorColor = [UIColor clearColor];
        
    } else {
        tableView.separatorColor = self.separatorColor;
    }
    
    tableView.scrollEnabled = enable;
}

#pragma mark - Table view delegate methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    id<UITableViewDataSource> dataSource = tableView.dataSource;
    
    if ([dataSource isKindOfClass:[DataSource class]]) {
        DataSource *cDataSource = (DataSource *)dataSource;
        return [cDataSource placeholderViewHeaderForTableView:tableView inSection:section];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    id<UITableViewDataSource> dataSource = tableView.dataSource;
    
    if ([dataSource isKindOfClass:[DataSource class]]) {
        DataSource *cDataSource = (DataSource *)dataSource;
        
        CGFloat verticalSpacedCovered = [self.topLayoutGuide length]+[self.bottomLayoutGuide length];
        return [cDataSource hightForHeaderViewForTableView:tableView verticalSpaceCovered:verticalSpacedCovered inSection:section];
    }
    
    return 0;
}

@end
