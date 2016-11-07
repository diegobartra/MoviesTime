//
//  PlaceholderView.h
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *buttonTitle;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle action:(dispatch_block_t)buttonAction;

@end

@interface TablePlaceholderView : UITableViewHeaderFooterView

- (void)showPlaceholderViewWithTitle:(NSString *)title message:(NSString *)message animated:(BOOL)animated;
- (void)showPlaceholderViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle buttonAction:(dispatch_block_t)buttonAction animated:(BOOL)animated;
- (void)hidePlaceholderViewAnimated:(BOOL)animated;

- (void)showActivityIndicator:(BOOL)show;

@end

@interface PlaceholderCell : UITableViewCell

- (void)showActivityIndicator:(BOOL)show;

@end
