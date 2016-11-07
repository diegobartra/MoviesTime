//
//  MovieInformationTableViewCell.h
//  MoviesTime
//
//  Created by Diego Bartra on 11/5/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
