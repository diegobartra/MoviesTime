//
//  UIViewController+ViewControllerShowing.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewControllerShowing)

- (BOOL)_willShowingViewControllerPushWithSender:(id)sender;
- (BOOL)_willShowingDetailViewControllerPushWithSender:(id)sender;

@end
