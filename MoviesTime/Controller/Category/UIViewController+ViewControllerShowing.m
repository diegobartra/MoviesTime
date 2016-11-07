//
//  UIViewController+ViewControllerShowing.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "UIViewController+ViewControllerShowing.h"

@implementation UIViewController (ViewControllerShowing)

- (BOOL)_willShowingViewControllerPushWithSender:(id)sender {
    
    UIViewController *target = [self targetViewControllerForAction:@selector(_willShowingViewControllerPushWithSender:)
                                                            sender:sender];
    if (target) {
        return [target _willShowingViewControllerPushWithSender:sender];
    } else {
        return NO;
    }
    
}

- (BOOL)_willShowingDetailViewControllerPushWithSender:(id)sender {

    UIViewController *target = [self targetViewControllerForAction:@selector(_willShowingDetailViewControllerPushWithSender:)
                                                            sender:sender];
    if (target) {
        return [target _willShowingDetailViewControllerPushWithSender:sender];
    } else {
        return NO;
    }
}

@end

@implementation UINavigationController (ViewControllerShowing)

- (BOOL)_willShowingViewControllerPushWithSender:(id)sender {
    
    return YES;
}

@end

@implementation UISplitViewController (ViewControllerShowing)

- (BOOL)_willShowingDetailViewControllerPushWithSender:(id)sender {
    
    if (self.collapsed) {
        UIViewController *target = [self.viewControllers lastObject];
        return [target _willShowingViewControllerPushWithSender:sender];
        
    } else {
        return NO;
    }
}

@end
