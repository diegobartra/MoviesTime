//
//  PlaceholderView.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/31/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "PlaceholderView.h"
#import "MoviesTimeStyleKit.h"

@interface PlaceholderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) void (^buttonAction)(void);
@property (nonatomic, copy) NSArray *constraints;

@end

@implementation PlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {

    @throw [NSException exceptionWithName:@"Initializer is not valid" reason:@"Use [PlaceholderView initWithFrame: title: message:] instead" userInfo:nil];
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message {

    return [self initWithFrame:frame title:title message:message buttonTitle:nil action:nil];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle action:(dispatch_block_t)buttonAction {

    self = [super initWithFrame:frame];
    
    if (!self)
        return nil;
    
    _title = [title copy];
    _message = [message copy];
    
    if (buttonTitle && buttonAction) {
        _buttonTitle = [buttonTitle copy];
        _buttonAction = [buttonAction copy];
    }
    
    UIColor *textColor = [MoviesTimeStyleKit placeholderColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19.5];
    _titleLabel.textColor = textColor;
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.5];
    _messageLabel.textColor = textColor;
    
    _button = [[UIButton alloc] init];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    [_button setTitleColor:[MoviesTimeStyleKit themeColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_button addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateViewHierarchy];
    
    return self;
}

- (void)updateViewHierarchy {

    if (_title) {
        [self addSubview:_titleLabel];
        _titleLabel.text = _title;
    } else {
        [_titleLabel removeFromSuperview];
    }
    
    if (_message) {
        [self addSubview:_messageLabel];
        _messageLabel.text = _message;
    } else {
        [_messageLabel removeFromSuperview];
    }
    
    if (_buttonTitle) {
        [self addSubview:_button];
        [_button setTitle:_buttonTitle forState:UIControlStateNormal];
        
    } else {
        [_button removeFromSuperview];
    }
    
    if (_constraints) {
        [NSLayoutConstraint deactivateConstraints:_constraints];
    }
    
    _constraints = nil;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {

    if (_constraints) {
        [super updateConstraints];
        return;
    }
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _messageLabel);
    UIView *lastView = self;
    NSLayoutAttribute lastAttribute = NSLayoutAttributeCenterY;
    CGFloat constant = 60;
    
    if (_titleLabel.superview) {
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_titleLabel]-(8)-|" options:0 metrics:nil views:views]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:lastView
                                                            attribute:lastAttribute
                                                           multiplier:1.0
                                                             constant:-constant]];
        lastView = _titleLabel;
        lastAttribute = NSLayoutAttributeBottom;
        constant = 20;
    }
    
    if (_messageLabel.superview) {
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_messageLabel]-(8)-|" options:0 metrics:nil views:views]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:lastView
                                                            attribute:lastAttribute
                                                           multiplier:1.0
                                                             constant:constant]];
        
        lastView = _messageLabel;
        lastAttribute = NSLayoutAttributeBottom;
        constant = 20;
    }
    
    if (_button.superview) {
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:120]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:40]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:lastView
                                                            attribute:lastAttribute
                                                           multiplier:1.0
                                                             constant:constant]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    _constraints = constraints;
    
    [super updateConstraints];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    if (_button.superview) {
        [_button setBackgroundImage:[MoviesTimeStyleKit imageOfBorderedButtonWithFrame:_button.bounds]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[MoviesTimeStyleKit imageOfHighlightedBorderedButtonWithFrame:_button.bounds]
                           forState:UIControlStateHighlighted];
    }
}

- (void)setTitle:(NSString *)title {

    if ([title isEqualToString:_title])
        return;
    
    _title = title;
    [self updateViewHierarchy];
}

- (void)setMessage:(NSString *)message {

    if ([message isEqualToString:_message])
        return;
    
    _message = message;
    [self updateViewHierarchy];
}

- (void)setButtonTitle:(NSString *)buttonTitle {

    if ([buttonTitle isEqualToString:_buttonTitle]) {
        return;
    }
    
    _buttonTitle = buttonTitle;
    [self updateViewHierarchy];
}

- (void)actionButtonTapped:(id)sender {

    if (self.buttonAction) {
        self.buttonAction();
    }
}

@end

@interface TablePlaceholderView ()

@property (nonatomic, strong) PlaceholderView *placeholderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation TablePlaceholderView

- (void)showPlaceholderViewWithTitle:(NSString *)title message:(NSString *)message animated:(BOOL)animated {

    [self showPlaceholderViewWithTitle:title message:message buttonTitle:nil buttonAction:nil animated:animated];
}

- (void)showPlaceholderViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle buttonAction:(dispatch_block_t)buttonAction animated:(BOOL)animated {

    PlaceholderView *oldPlaceholderView = self.placeholderView;
    if (oldPlaceholderView) {
        if ([oldPlaceholderView.title isEqualToString:title] && [oldPlaceholderView.message isEqualToString:message])
            return;
        else
            [self hidePlaceholderViewAnimated:NO];
    }
    
    [self showActivityIndicator:NO];
    
    self.placeholderView = [[PlaceholderView alloc] initWithFrame:CGRectZero title:title message:message buttonTitle:buttonTitle action:buttonAction];
    _placeholderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_placeholderView];
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *views = @{@"placeholderView" : _placeholderView};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[placeholderView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[placeholderView]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:constraints];
    
    _placeholderView.alpha = 0.0;
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            _placeholderView.alpha = 1.0;
        } completion:nil];
        
    } else {
        [UIView performWithoutAnimation:^{
            _placeholderView.alpha = 1.0;
        }];
    }
}

- (void)hidePlaceholderViewAnimated:(BOOL)animated {

    PlaceholderView *placeholderView = self.placeholderView;
    if (!placeholderView)
        return;
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            placeholderView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            if (finished)
                [placeholderView removeFromSuperview];
        }];
        
    } else {
        [UIView performWithoutAnimation:^{
            placeholderView.alpha = 0.0;
            [placeholderView removeFromSuperview];
        }];
    }
    
    self.placeholderView = nil;
}

- (void)showActivityIndicator:(BOOL)show {

    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.color = [UIColor grayColor];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *contentView = self.contentView;
        [contentView insertSubview:_activityIndicator atIndex:0];
        
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0]];
        [self addConstraints:constraints];
    }
    
    _activityIndicator.hidden = !show;
    
    if (show)
        [_activityIndicator startAnimating];
    else
        [_activityIndicator stopAnimating];
}

@end

@interface PlaceholderCell ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PlaceholderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.color = [UIColor grayColor];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *contentView = self.contentView;
        [contentView insertSubview:_activityIndicator atIndex:0];
        
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0]];
        [self addConstraints:constraints];
    }
    
    return self;
}

- (void)showActivityIndicator:(BOOL)show {
    
    _activityIndicator.hidden = !show;
    
    if (show)
        [_activityIndicator startAnimating];
    else
        [_activityIndicator stopAnimating];
}

@end
