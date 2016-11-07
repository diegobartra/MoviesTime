//
//  EmptyViewController.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/27/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "EmptyViewController.h"

@interface EmptyViewController ()

@end

@implementation EmptyViewController

- (void)loadView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"No Movie Selected";
    label.textColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    [view addSubview:label];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    self.view = view;
}

@end
