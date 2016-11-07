//
//  MovieHeaderTableViewCell.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/6/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
