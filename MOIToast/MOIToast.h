//
//  MOIToast.h
//  MOIToastDemo
//
//  Created by mconintet on 10/28/15.
//  Copyright © 2015 mconintet. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MOITOAST_FONT_NAME
#define MOITOAST_FONT_NAME @"moitoast"
#endif

#ifndef MOITOAST_FONT_ICON_SIZE
#define MOITOAST_FONT_ICON_SIZE 14
#endif

#ifndef MOITOAST_TITLE_FONT_SIZE
#define MOITOAST_TITLE_FONT_SIZE 14
#endif

#ifndef MOITOAST_MESSAGE_FONT_SIZE
#define MOITOAST_MESSAGE_FONT_SIZE 14
#endif

#ifndef MOITOAST_WIDTH
#define MOITOAST_WIDTH 0.9
#endif

#ifndef MOITOAST_BKG_COLOR_SUCCESS
#define MOITOAST_BKG_COLOR_SUCCESS 0x51A351
#endif

#ifndef MOITOAST_BKG_COLOR_INFO
#define MOITOAST_BKG_COLOR_INFO 0x2F96B4
#endif

#ifndef MOITOAST_BKG_COLOR_WARNING
#define MOITOAST_BKG_COLOR_WARNING 0xF89406
#endif

#ifndef MOITOAST_BKG_COLOR_ERROR
#define MOITOAST_BKG_COLOR_ERROR 0xBD362F
#endif

#ifndef MOITOAST_FONT_ICON_SUCCESS
#define MOITOAST_FONT_ICON_SUCCESS 0xe801
#endif

#ifndef MOITOAST_FONT_ICON_INFO
#define MOITOAST_FONT_ICON_INFO 0xe803
#endif

#ifndef MOITOAST_FONT_ICON_WARNING
#define MOITOAST_FONT_ICON_WARNING 0xe802
#endif

#ifndef MOITOAST_FONT_ICON_ERROR
#define MOITOAST_FONT_ICON_ERROR 0xe800
#endif

#ifndef MOITOAST_MARGIN
#define MOITOAST_MARGIN 5
#endif

typedef NS_ENUM(NSInteger, MOIToastType) {
    MOIToastTypeSuccess = 0,
    MOIToastTypeInfo = 1,
    MOIToastTypeWarning = 2,
    MOIToastTypeError = 3,
};

@interface MOIToast : UIView

@property (nonatomic, strong) UILabel* icon;
@property (nonatomic, strong) UILabel* title;
@property (nonatomic, assign, readonly) BOOL top;
@property (nonatomic, strong) UILabel* message;
@property (nonatomic, weak, readonly) UIView* parent;
@property (nonatomic, assign, readonly) MOIToastType type;

- (instancetype)initWithParentView:(UIView*)parent type:(MOIToastType)type top:(BOOL)top;

- (void)hideWithDuration:(NSTimeInterval)duration
              completion:(void (^)(void))completion;

+ (void)successWithin:(UIView*)parent
                  top:(BOOL)top
               margin:(CGFloat)margin
                title:(NSString*)title
              message:(NSString*)message
             duration:(NSTimeInterval)duration
              timeout:(NSTimeInterval)timeout
           completion:(void (^)(void))completion;

+ (void)infoWithin:(UIView*)parent
               top:(BOOL)top
            margin:(CGFloat)margin
             title:(NSString*)title
           message:(NSString*)message
          duration:(NSTimeInterval)duration
           timeout:(NSTimeInterval)timeout
        completion:(void (^)(void))completion;

+ (void)warningWithin:(UIView*)parent
                  top:(BOOL)top
               margin:(CGFloat)margin
                title:(NSString*)title
              message:(NSString*)message
             duration:(NSTimeInterval)duration
              timeout:(NSTimeInterval)timeout
           completion:(void (^)(void))completion;

+ (void)errorWithin:(UIView*)parent
                top:(BOOL)top
             margin:(CGFloat)margin
              title:(NSString*)title
            message:(NSString*)message
           duration:(NSTimeInterval)duration
            timeout:(NSTimeInterval)timeout
         completion:(void (^)(void))completion;

@end
