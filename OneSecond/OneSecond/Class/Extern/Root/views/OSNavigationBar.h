//
//  OSNavigationBar.h
//  OneSecond
//
//  Created by JunhuaRao on 15/10/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNavigationBarButtonFont    [OSFont nextDayFontWithSize:ButtonNavFontSize]
#define kNavigationBarTitleFont     [OSFont navigationBarTitleFont]

#define kNavigationBarButtonNormalColor     [OSColor titleTextColor]
#define kNavigationBarButtonHighlightColor  [[UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0] colorWithAlphaComponent:0.4]
#define kNavigationBarButtonDisableColor    [[UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0] colorWithAlphaComponent:0.4]

#define kNavigationBarTitleViewMaxWidth 190
#define kNavigationBarTitleViewMaxHeight 44

@interface OSNavigationBar : UINavigationBar

/**
 *  通过标题生成UIBarButtonItem
 *
 *  @param title 标题
 *  @param target 事件响应对象
 *  @param action 事件响应方法
 */
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  通过标题和颜色生成UIBarButtonItem
 *
 *  @param title  标题
 *  @param color  文本颜色
 *  @param target 事件响应对象
 *  @param action 事件响应方法
 */
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action;


/**
 *  通过自定义视图生成UIBarButtonItem
 *
 *  @param view 自定义视图
 */
+ (UIBarButtonItem *)createBarButtonItemWithCustomView:(UIView *)view;


/**
 *  通过图片生成UIBarButtonItem
 *
 *  @param image  图片
 *  @param style  类型
 *  @param target 事件响应对象
 *  @param action 事件响应方法
 */
+ (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

/**
 *  通过标题生成UIBarButtonItem
 *
 *  @param title  标题
 *  @param style  类型
 *  @param target 事件响应对象
 *  @param action 事件响应方法
 */
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

@end
