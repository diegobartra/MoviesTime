//
//  UIViewController+MovieContent.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "UIViewController+MovieContent.h"
#import "MovieDetailViewController.h"

@implementation UIViewController (MovieContent)

- (BOOL)_containsMovie {
    
    return NO;
}

@end

@implementation MovieDetailViewController (MovieContent)

- (BOOL)_containsMovie {
    
    return self.movie? YES : NO;
}

@end

@implementation UINavigationController (MovieContent)

- (BOOL)_containsMovie {
    
    for (UIViewController *controller in self.viewControllers) {
        if ([controller _containsMovie]) {
            return YES;
        }
    }
    
    return NO;
}

@end
