//
//  MovieDetailViewController.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/27/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;

@interface MovieDetailViewController : UITableViewController

@property (nonatomic, strong) Movie *movie;

@end
