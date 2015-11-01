//
//  MOIToast.m
//  MOIToastDemo
//
//  Created by mconintet on 10/28/15.
//  Copyright © 2015 mconintet. All rights reserved.
//

#import "MOIToast.h"

#define UICOLOR_FROM_RGB(rgb)                              \
    [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0 \
                    green:((rgb & 0x00FF00) >> 8) / 255.0  \
                     blue:(rgb & 0x0000FF) / 255.0         \
                    alpha:1.0]

#define FONT_NSSTRING(utf8CharCode)                  \
    ({                                               \
        unichar c = (unichar)utf8CharCode;           \
        [NSString stringWithCharacters:&c length:1]; \
    })

@interface MOIToast ()
@end

static NSMutableDictionary* duplicateDict = nil;

@implementation MOIToast

- (instancetype)initWithParentView:(UIView*)parent type:(MOIToastType)type top:(BOOL)top
{
    self = [super init];
    if (self) {
        _top = top;

        _parent = parent;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;

        _icon = ({
            UILabel* label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:MOITOAST_FONT_NAME size:MOITOAST_FONT_ICON_SIZE];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });

        _title = ({
            UILabel* label = [[UILabel alloc] init];
            label.font = [UIFont boldSystemFontOfSize:MOITOAST_TITLE_FONT_SIZE];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = [UIColor whiteColor];
            [self addSubview:label];
            label;
        });

        _message = ({
            UILabel* label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:MOITOAST_MESSAGE_FONT_SIZE];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            label.textColor = [UIColor whiteColor];
            [self addSubview:label];
            label;
        });

        [self setType:type];

        [self setNeedsUpdateConstraints];
        [parent addSubview:self];
    }
    return self;
}

- (void)setType:(MOIToastType)type
{
    NSInteger color = 0;
    NSInteger icon = 0;
    switch (type) {
    case MOIToastTypeSuccess:
        color = MOITOAST_BKG_COLOR_SUCCESS;
        icon = MOITOAST_FONT_ICON_SUCCESS;
        break;
    case MOIToastTypeError:
        color = MOITOAST_BKG_COLOR_ERROR;
        icon = MOITOAST_FONT_ICON_ERROR;
        break;
    case MOIToastTypeInfo:
        color = MOITOAST_BKG_COLOR_INFO;
        icon = MOITOAST_FONT_ICON_INFO;
        break;
    case MOIToastTypeWarning:
        color = MOITOAST_BKG_COLOR_WARNING;
        icon = MOITOAST_FONT_ICON_WARNING;
        break;
    default:
        break;
    }

    self.backgroundColor = UICOLOR_FROM_RGB(color);
    self.icon.text = FONT_NSSTRING(icon);
    self.alpha = 0;
}

- (void)updateConstraints
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxWith = screenWidth * MOITOAST_WIDTH;

    NSString* format = [NSString
        stringWithFormat:@"H:[toast(<=%f)]", maxWith];
    NSArray* constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:format
                            options:0
                            metrics:nil
                              views:@{
                                  @"toast" : self,
                              }];
    [_parent addConstraints:constraints];

    [_parent addConstraint:[NSLayoutConstraint
                               constraintWithItem:self
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:_parent
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.f
                                         constant:0.f]];

    constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"H:|-5-[icon(<=25)]-5-[title]-5-|"
                            options:0
                            metrics:nil
                              views:@{
                                  @"icon" : _icon,
                                  @"title" : _title
                              }];
    [self addConstraints:constraints];

    constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"H:|-5-[icon(<=25)]-5-[message]-5-|"
                            options:0
                            metrics:nil
                              views:@{
                                  @"icon" : _icon,
                                  @"message" : _message
                              }];
    [self addConstraints:constraints];

    constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"V:|-5-[icon]-5-|"
                            options:0
                            metrics:nil
                              views:@{
                                  @"icon" : _icon
                              }];
    [self addConstraints:constraints];

    [super updateConstraints];
}

- (void)setMarginBottom:(CGFloat)marginBottom
{
    NSString* format = [NSString stringWithFormat:@"V:[toast]-%f-|", marginBottom];
    NSArray* constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:format
                            options:0
                            metrics:nil
                              views:@{
                                  @"toast" : self,
                              }];
    [_parent addConstraints:constraints];
}

- (void)setMarginTop:(CGFloat)marginTop
{
    NSString* format = [NSString stringWithFormat:@"V:|-%f-[toast]", marginTop];
    NSArray* constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:format
                            options:0
                            metrics:nil
                              views:@{
                                  @"toast" : self,
                              }];
    [_parent addConstraints:constraints];
}

- (void)hideWithDuration:(NSTimeInterval)duration
              completion:(void (^)(void))completion
{
    [UIView animateWithDuration:duration
        animations:^{
            self.alpha = 0;
        }
        completion:^(BOOL finished) {
            if (completion != nil) {
                [self removeFromSuperview];
                completion();
            }
        }];
}

+ (NSMutableArray*)getShowingTopToasts
{
    static NSMutableArray* coll = nil;
    if (coll == nil) {
        coll = [[NSMutableArray alloc] init];
    }
    return coll;
}

+ (NSMutableArray*)getShowingBottomToasts
{
    static NSMutableArray* coll = nil;
    if (coll == nil) {
        coll = [[NSMutableArray alloc] init];
    }
    return coll;
}

+ (CGFloat)getShowingTopToastsHeight
{
    NSMutableArray* coll = [self getShowingTopToasts];
    CGFloat ret = 0;
    for (MOIToast* toast in coll) {
        ret += [toast systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + MOITOAST_MARGIN;
    }
    return ret;
}

+ (CGFloat)getShowingBottomToastsHeight
{
    NSMutableArray* coll = [self getShowingBottomToasts];
    CGFloat ret = 0;
    for (MOIToast* toast in coll) {
        ret += [toast systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + MOITOAST_MARGIN;
    }
    return ret;
}

+ (NSMutableDictionary*)duplicateDict
{
    if (duplicateDict == nil) {
        duplicateDict = [[NSMutableDictionary alloc] init];
    }
    return duplicateDict;
}

+ (NSString*)duplicateKeyWithTitle:(NSString*)title message:(NSString*)message
{
    if (title == nil) {
        title = @"";
    }

    if (message == nil) {
        message = @"";
    }

    return [NSString stringWithFormat:@"%@%@", title, message];
}

+ (void)addDuplicateTitle:(NSString*)title message:(NSString*)message
{
    NSString* key = [self duplicateKeyWithTitle:title message:message];
    NSMutableDictionary* dict = [self duplicateDict];
    [dict setObject:@"" forKey:key];
}

+ (BOOL)isDuplicateTitle:(NSString*)title message:(NSString*)message
{
    NSString* key = [self duplicateKeyWithTitle:title message:message];
    NSMutableDictionary* dict = [self duplicateDict];
    return [dict objectForKey:key] != nil;
}

+ (void)delDuplicateTitle:(NSString*)title message:(NSString*)message
{
    NSString* key = [self duplicateKeyWithTitle:title message:message];
    NSMutableDictionary* dict = [self duplicateDict];
    [dict removeObjectForKey:key];
}

+ (void)successWithin:(UIView*)parent
                  top:(BOOL)top
               margin:(CGFloat)margin
                title:(NSString*)title
              message:(NSString*)message
             duration:(NSTimeInterval)duration
              timeout:(NSTimeInterval)timeout
           completion:(void (^)(void))completion
{
    if ([self isDuplicateTitle:title message:message]) {
        return;
    }
    [self addDuplicateTitle:title message:message];

    MOIToast* toast = [[MOIToast alloc] initWithParentView:parent type:MOIToastTypeSuccess top:top];
    toast.title.text = title;
    toast.message.text = message;

    if (top) {
        CGFloat marinTop = [self getShowingTopToastsHeight] + margin;
        [toast setMarginTop:marinTop];
        [[self getShowingTopToasts] addObject:toast];
    }
    else {
        CGFloat marinBottom = [self getShowingBottomToastsHeight] + margin;
        [toast setMarginBottom:marinBottom];
        [[self getShowingBottomToasts] addObject:toast];
    }

    NSArray* constraints = nil;
    if (title == nil) {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-4-[message]-5-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"message" : toast.message,
                                  }];
        [toast addConstraints:constraints];
    }
    else {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-5-[title]-5-[message]-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"title" : toast.title,
                                      @"message" : toast.message
                                  }];
        [toast addConstraints:constraints];
    }

    [UIView animateWithDuration:duration
        animations:^{
            toast.alpha = 0.8;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [toast hideWithDuration:duration
                             completion:^{
                                 if (toast.top) {
                                     [[self getShowingTopToasts] removeObject:toast];
                                 }
                                 else {
                                     [[self getShowingBottomToasts] removeObject:toast];
                                 }

                                 [self delDuplicateTitle:title message:message];
                                 if (completion != nil) {
                                     completion();
                                 }
                             }];
            });
        }];
}

+ (void)infoWithin:(UIView*)parent
               top:(BOOL)top
            margin:(CGFloat)margin
             title:(NSString*)title
           message:(NSString*)message
          duration:(NSTimeInterval)duration
           timeout:(NSTimeInterval)timeout
        completion:(void (^)(void))completion
{
    if ([self isDuplicateTitle:title message:message]) {
        return;
    }
    [self addDuplicateTitle:title message:message];

    MOIToast* toast = [[MOIToast alloc] initWithParentView:parent type:MOIToastTypeInfo top:top];
    toast.title.text = title;
    toast.message.text = message;

    if (top) {
        CGFloat marinTop = [self getShowingTopToastsHeight] + margin;
        [toast setMarginTop:marinTop];
        [[self getShowingTopToasts] addObject:toast];
    }
    else {
        CGFloat marinBottom = [self getShowingBottomToastsHeight] + margin;
        [toast setMarginBottom:marinBottom];
        [[self getShowingBottomToasts] addObject:toast];
    }

    NSArray* constraints = nil;
    if (title == nil) {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-4-[message]-5-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"message" : toast.message,
                                  }];
        [toast addConstraints:constraints];
    }
    else {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-5-[title]-5-[message]-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"title" : toast.title,
                                      @"message" : toast.message
                                  }];
        [toast addConstraints:constraints];
    }

    [UIView animateWithDuration:duration
        animations:^{
            toast.alpha = 0.8;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [toast hideWithDuration:duration
                                 completion:^{
                                     if (toast.top) {
                                         [[self getShowingTopToasts] removeObject:toast];
                                     }
                                     else {
                                         [[self getShowingBottomToasts] removeObject:toast];
                                     }

                                     [self delDuplicateTitle:title message:message];
                                     if (completion != nil) {
                                         completion();
                                     }
                                 }];
                });
        }];
}

+ (void)warningWithin:(UIView*)parent
                  top:(BOOL)top
               margin:(CGFloat)margin
                title:(NSString*)title
              message:(NSString*)message
             duration:(NSTimeInterval)duration
              timeout:(NSTimeInterval)timeout
           completion:(void (^)(void))completion
{
    if ([self isDuplicateTitle:title message:message]) {
        return;
    }
    [self addDuplicateTitle:title message:message];

    MOIToast* toast = [[MOIToast alloc] initWithParentView:parent type:MOIToastTypeWarning top:top];
    toast.title.text = title;
    toast.message.text = message;

    if (top) {
        CGFloat marinTop = [self getShowingTopToastsHeight] + margin;
        [toast setMarginTop:marinTop];
        [[self getShowingTopToasts] addObject:toast];
    }
    else {
        CGFloat marinBottom = [self getShowingBottomToastsHeight] + margin;
        [toast setMarginBottom:marinBottom];
        [[self getShowingBottomToasts] addObject:toast];
    }

    NSArray* constraints = nil;
    if (title == nil) {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-4-[message]-5-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"message" : toast.message,
                                  }];
        [toast addConstraints:constraints];
    }
    else {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-5-[title]-5-[message]-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"title" : toast.title,
                                      @"message" : toast.message
                                  }];
        [toast addConstraints:constraints];
    }

    [UIView animateWithDuration:duration
        animations:^{
            toast.alpha = 0.8;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [toast hideWithDuration:duration
                                 completion:^{
                                     if (toast.top) {
                                         [[self getShowingTopToasts] removeObject:toast];
                                     }
                                     else {
                                         [[self getShowingBottomToasts] removeObject:toast];
                                     }

                                     [self delDuplicateTitle:title message:message];
                                     if (completion != nil) {
                                         completion();
                                     }
                                 }];
                });
        }];
}

+ (void)errorWithin:(UIView*)parent
                top:(BOOL)top
             margin:(CGFloat)margin
              title:(NSString*)title
            message:(NSString*)message
           duration:(NSTimeInterval)duration
            timeout:(NSTimeInterval)timeout
         completion:(void (^)(void))completion
{
    if ([self isDuplicateTitle:title message:message]) {
        return;
    }
    [self addDuplicateTitle:title message:message];

    MOIToast* toast = [[MOIToast alloc] initWithParentView:parent type:MOIToastTypeError top:top];
    toast.title.text = title;
    toast.message.text = message;

    if (top) {
        CGFloat marinTop = [self getShowingTopToastsHeight] + margin;
        [toast setMarginTop:marinTop];
        [[self getShowingTopToasts] addObject:toast];
    }
    else {
        CGFloat marinBottom = [self getShowingBottomToastsHeight] + margin;
        [toast setMarginBottom:marinBottom];
        [[self getShowingBottomToasts] addObject:toast];
    }

    NSArray* constraints = nil;
    if (title == nil) {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-4-[message]-5-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"message" : toast.message,
                                  }];
        [toast addConstraints:constraints];
    }
    else {
        constraints = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-5-[title]-5-[message]-|"
                                options:0
                                metrics:nil
                                  views:@{
                                      @"title" : toast.title,
                                      @"message" : toast.message
                                  }];
        [toast addConstraints:constraints];
    }

    [UIView animateWithDuration:duration
        animations:^{
            toast.alpha = 0.8;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [toast hideWithDuration:duration
                                 completion:^{
                                     if (toast.top) {
                                         [[self getShowingTopToasts] removeObject:toast];
                                     }
                                     else {
                                         [[self getShowingBottomToasts] removeObject:toast];
                                     }

                                     [self delDuplicateTitle:title message:message];
                                     if (completion != nil) {
                                         completion();
                                     }
                                 }];
                });
        }];
}

@end
