//
//  MoviesViewController.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/27/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "MoviesViewController.h"
#import "ServerConfiguration.h"
#import "GenreStore.h"
#import "UIViewController+ViewControllerShowing.h"
#import "Movie.h"
#import "MovieListDataSource.h"
#import "MovieDetailViewController.h"

@interface MoviesViewController ()

@property (nonatomic, strong) MovieListDataSource *dataSource;

@end

@implementation MoviesViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIViewControllerShowDetailTargetDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailTargetDidChange:)
                                                 name:UIViewControllerShowDetailTargetDidChangeNotification object:nil];
        
    UITableView *tableView = self.tableView;
    
    tableView.estimatedRowHeight = 90;
    tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataSource = [self newMovieListDataSource];
    tableView.dataSource = (id<UITableViewDataSource>)self.dataSource;
}

- (MovieListDataSource *)newMovieListDataSource {

    MovieListDataSource *dataSource = [[MovieListDataSource alloc] init];
    
    dataSource.errorTitle = @"Unable To Load Movies";
    dataSource.errorMessage = @"A problem prevented loading the movies. Please try again later.";
    dataSource.errorButtonTitle = @"Retry";
    __weak MovieListDataSource *weakDataSource = dataSource;
    dataSource.errorButtonAction = ^{
        
        [[ServerConfiguration defaultConfiguration] fetch];
        [[GenreStore sharedStore] fetchGenres];
        [weakDataSource loadContent];
        [self.tableView reloadData];
    };
    
    dataSource.noContentTitle = @"There Are No Movies";
    dataSource.noContentMessage = @"Please try again later.";
    
    return dataSource;
}

- (IBAction)refresh:(UIRefreshControl *)sender
{
    self.dataSource.currentPage = 0;
    self.dataSource.numberOfPages = 0;
    [self.dataSource loadContent];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    BOOL pushes = [self _willShowingDetailViewControllerPushWithSender:self];
    
    if (pushes) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetailMovie"]) {
        
        if ([sender isKindOfClass:[UITableViewCell class]]) {

            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            
            Movie *movie = [self.dataSource itemAtIndexPath:indexPath];
            
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            MovieDetailViewController *movieDetailViewController = (MovieDetailViewController *)navController.topViewController;
            movieDetailViewController.movie = movie;
        }
    }
}

#pragma mark - Notifications

- (void)showDetailTargetDidChange:(NSNotification *)notification {

    UITableView *tableView = self.tableView;
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

@end
