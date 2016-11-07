//
//  MovieDetailViewController.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/27/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "ServerConfiguration.h"
#import "GenreStore.h"
#import "Movie.h"
#import "Genre.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MovieHeaderTableViewCell.h"
#import "MovieOverviewTableViewCell.h"
#import "MovieInformationTableViewCell.h"

@interface MovieDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    return _dateFormatter;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Movie *movie = self.movie;
    
    if (indexPath.row == 0) {
        
        MovieHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieHeaderTableViewCell" forIndexPath:indexPath];
        
        NSURL *posterURL = [[ServerConfiguration defaultConfiguration] imageURLWithSize:PosterImageSizeSmall path:movie.posterPath];
        NSURL *backdropURL = [[ServerConfiguration defaultConfiguration] imageURLWithSize:BackdropImageSizeLarge path:movie.backdropPath];
        
        [cell.posterImageView sd_setImageWithURL:posterURL placeholderImage:[UIImage imageNamed:@"MoviePosterPlaceholder"]];
        [cell.backdropImageView sd_setImageWithURL:backdropURL placeholderImage:[UIImage imageNamed:@"MovieBackdropPlaceholder"]];
        cell.titleLabel.text = movie.title;
        
        return cell;
    
    } else if (indexPath.row == 1) {
        
        MovieOverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieOverviewTableViewCell" forIndexPath:indexPath];
        
        cell.overviewLabel.text = (movie.overview && ![movie.overview isEqualToString:@""])? movie.overview : @"No description available.";
        
        return cell;
        
    } else {
        
        MovieInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieInformationTableViewCell" forIndexPath:indexPath];
        
        NSMutableArray *genreNames = [[NSMutableArray alloc] initWithCapacity:[movie.genreIDs count]];
        for (NSNumber *genreID in movie.genreIDs) {
            Genre *genre = [[GenreStore sharedStore] genreForKey:genreID];
            [genreNames addObject:genre.name];
        }
        
        NSString *genreString = [genreNames componentsJoinedByString:@" & "];
        
        cell.genreLabel.text = (genreString && ![genreString isEqualToString:@""])? genreString : @"No genre available";
        cell.adultLabel.text = movie.adult? @"Yes" : @"No";
        cell.dateLabel.text = [self.dateFormatter stringFromDate:movie.releaseDate];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

@end
