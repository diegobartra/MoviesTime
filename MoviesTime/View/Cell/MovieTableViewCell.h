//
//  MovieTableViewCell.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end
