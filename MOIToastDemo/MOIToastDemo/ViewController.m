//
//  ViewController.m
//  MOIToastDemo
//
//  Created by mconintet on 10/28/15.
//  Copyright © 2015 mconintet. All rights reserved.
//

#import "ViewController.h"
#import "MOIToast.h"
#import "UIButton+SetBackgroundColor.h"

#define UICOLOR_FROM_RGB(rgb)                              \
    [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0 \
                    green:((rgb & 0x00FF00) >> 8) / 255.0  \
                     blue:(rgb & 0x0000FF) / 255.0         \
                    alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton* button = ({
        UIButton* btn = [[UIButton alloc] init];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = UICOLOR_FROM_RGB(0x366EEC);
        [btn setTitle:@"Show" forState:UIControlStateNormal];
        [btn setBackgroundColor:UICOLOR_FROM_RGB(0x2583D8)
                       forState:UIControlStateHighlighted];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3.0f;
        [self.view addSubview:btn];
        btn;
    });

    NSArray* constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"H:[btn(100)]"
                            options:0
                            metrics:0
                              views:@{
                                  @"btn" : button
                              }];
    [self.view addConstraints:constraints];

    constraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"V:[btn(40)]"
                            options:0
                            metrics:0
                              views:@{
                                  @"btn" : button
                              }];
    [self.view addConstraints:constraints];

    NSLayoutConstraint* constraint = [NSLayoutConstraint
        constraintWithItem:button
                 attribute:NSLayoutAttributeCenterX
                 relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                 attribute:NSLayoutAttributeCenterX
                multiplier:1
                  constant:0];
    [self.view addConstraint:constraint];

    constraint = [NSLayoutConstraint
        constraintWithItem:button
                 attribute:NSLayoutAttributeCenterY
                 relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                 attribute:NSLayoutAttributeCenterY
                multiplier:1
                  constant:0];
    [self.view addConstraint:constraint];

    [button addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitButtonClicked:(id)sender
{
    [MOIToast successWithin:self.view
                        top:YES
                     margin:64
                      title:nil
                    message:@"success1"
                   duration:1
                    timeout:3
                 completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MOIToast successWithin:self.view
                            top:YES
                         margin:64
                          title:nil
                        message:@"success2"
                       duration:1
                        timeout:3
                     completion:nil];
    });

    [MOIToast successWithin:self.view
                        top:YES
                     margin:64
                      title:nil
                    message:@"success3"
                   duration:1
                    timeout:3
                 completion:nil];

    [MOIToast successWithin:self.view
                        top:NO
                     margin:10
                      title:nil
                    message:@"success4"
                   duration:1
                    timeout:3
                 completion:nil];
    [MOIToast successWithin:self.view
                        top:NO
                     margin:10
                      title:nil
                    message:@"success5"
                   duration:1
                    timeout:3
                 completion:nil];

    [MOIToast infoWithin:self.view
                     top:NO
                  margin:10
                   title:nil
                 message:@"info1"
                duration:1
                 timeout:3
              completion:nil];

    [MOIToast infoWithin:self.view
                     top:YES
                  margin:64
                   title:nil
                 message:@"info2"
                duration:1
                 timeout:3
              completion:nil];

    [MOIToast warningWithin:self.view
                        top:NO
                     margin:10
                      title:nil
                    message:@"warning1"
                   duration:1
                    timeout:3
                 completion:nil];
    [MOIToast warningWithin:self.view
                        top:YES
                     margin:64
                      title:nil
                    message:@"warning2"
                   duration:1
                    timeout:3
                 completion:nil];

    [MOIToast errorWithin:self.view
                      top:NO
                   margin:10
                    title:nil
                  message:@"error1"
                 duration:1
                  timeout:3
               completion:nil];
    [MOIToast errorWithin:self.view
                      top:YES
                   margin:64
                    title:nil
                  message:@"error2"
                 duration:1
                  timeout:3
               completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
