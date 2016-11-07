//
//  MovieHeaderTableViewCell.m
//  MoviesTime
//
//  Created by Diego Bartra on 11/6/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "MovieHeaderTableViewCell.h"

@implementation MovieHeaderTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.posterImageView.layer.cornerRadius = 3;
    self.posterImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
