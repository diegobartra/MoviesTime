//
//  MovieListDataSource.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "MovieListDataSource.h"
#import "DataAccessManager.h"
#import "DataLoadingManager.h"
#import "ServerConfiguration.h"
#import "GenreStore.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Movie.h"
#import "Genre.h"
#import "MovieTableViewCell.h"

@interface MovieListDataSource ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MovieListDataSource

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    return self;
}

- (void)loadContent {

    [self loadContentWithBlock:^(Loading *loading) {
        
        [[DataAccessManager manager] fetchUpcomingMoviesInPage:self.currentPage+1 completionBlock:^(NSUInteger page, NSUInteger numberOfPages, NSArray *movies, NSError *error) {
            
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (!error) {
                
                if ([movies count]) {
                    
                    [[DataLoadingManager sharedManager] enqueueSuccessBlock:^{
                        
                        void (^update)(MovieListDataSource *me) = nil;
                        
                        if (page == 1) {
                            update = ^(MovieListDataSource *me) {
                                me.items = movies;
                            };
                            
                        } else {
                            update = ^(MovieListDataSource *me) {
                                [me insertItems:movies];
                            };
                        }
                        
                        [loading updateWithContent:^(MovieListDataSource *me) {
                            [me updatePagingWithCurrentPage:page numberOfPages:numberOfPages];
                            update(me);
                        }];
                        
                    } errorBlock:^{
                        [loading doneWithError:nil];
                    }];
                    
                    
                } else {
                    [loading updateWithNoContent:^(MovieListDataSource *me) {
                        me.items = @[];
                    }];
                }
                
            } else {
                [loading doneWithError:error];
            }
        }];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView aCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell" forIndexPath:indexPath];
    
    Movie *movie = [self itemAtIndexPath:indexPath];

    NSMutableArray *genreNames = [[NSMutableArray alloc] initWithCapacity:[movie.genreIDs count]];
    for (NSNumber *genreID in movie.genreIDs) {
        Genre *genre = [[GenreStore sharedStore] genreForKey:genreID];
        [genreNames addObject:genre.name];
    }
    
    NSString *genreString = [genreNames componentsJoinedByString:@" & "];
    NSURL *posterURL = [[ServerConfiguration defaultConfiguration] imageURLWithSize:PosterImageSizeSmall
                                                                               path:movie.posterPath];
    
    cell.titleLabel.text = movie.title;
    cell.genreLabel.text = (genreString && ![genreString isEqualToString:@""])? genreString : @"No genre";
    cell.dateLabel.text = [self.dateFormatter stringFromDate:movie.releaseDate];
    [cell.posterImageView sd_setImageWithURL:posterURL placeholderImage:[UIImage imageNamed:@"MoviePosterPlaceholder"]];
    
    return cell;
}

@end
