//
//  UIViewController+OSNavigationBar.h
//  OneSecond
//
//  Created by JunhuaRao on 15/10/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (OSNavigationBar)

#pragma mark 设置界面标题
/**
 *  设置界面标题
 *
 *  @param title 标题名
 */
- (void)setCustomTitle:(NSString *)title;

#pragma mark 设置界面标题
/**
 *  设置界面标题
 *
 *  @param title 标题名
 *  @param color 标题颜色
 */
- (void)setCustomTitle:(NSString *)title withColor:(UIColor *)color;

#pragma mark 增加左上角按钮
/**
 *  增加左上角按钮
 *
 *  @param item 左上角UIBarButtonItem
 */
- (void)setLeftBarButtonItem:(UIBarButtonItem *)item;

#pragma mark 增加左上角按钮
/**
 *  增加左上角按钮
 *
 *  @param target 消息绑定目标
 *  @param action 消息绑定方法
 */
- (void)setLeftBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector;

#pragma mark 增加左上角按钮并设置颜色
/**
 *  增加左上角按钮
 *
 *  @param color  文本颜色
 *  @param target 消息绑定目标
 *  @param action 消息绑定方法
 */
- (void)setLeftBarButtonWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)selector;


#pragma mark 增加右上角按钮
/**
 *  增加右上角按钮
 *
 *  @param item 右上角UIBarButtonItem
 */
- (void)setRightBarButtonItem:(UIBarButtonItem *)item;

#pragma mark 增加右上角按钮
/**
 *  增加右上角按钮
 *
 *  @param target 消息绑定目标
 *  @param action 消息绑定方法
 */
- (void)setRightBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector;

#pragma mark 增加右上角按钮并设置颜色
/**
 *  增加右上角按钮
 *
 *  @param color  文本颜色
 *  @param target 消息绑定目标
 *  @param action 消息绑定方法
 */
- (void)setRightBarButtonWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)selector;

#pragma mark 增加返回按钮
/**
 *  增加返回按钮(默认是箭头)
 *
 *  @param target 消息绑定目标
 *  @param action 消息绑定方法
 */
- (void)setBackBarButtonWithTarget:(id)target action:(SEL)selector;


#pragma mark 设置返回按键是否隐藏
/**
 *  设置返回按键是否隐藏
 *
 *  @param hidden 隐藏标志位
 */
- (void)setBackBarButtonItemHidden:(BOOL)hidden;

#pragma mark 设置左上角按键是否隐藏
/**
 *  设置左上角按键是否隐藏
 *
 *  @param hidden 隐藏标志位
 */
- (void)setLeftBarButtonItemHidden:(BOOL)hidden;

#pragma mark 设置右上角按键是否隐藏
/**
 *  设置右上角按键是否隐藏
 *
 *  @param hidden 隐藏标志位
 */
- (void)setRightBarButtonItemHidden:(BOOL)hidden;

#pragma mark 设置左上角按键是否有效点击
/**
 *  设置左上角按键是否有效点击
 *
 *  @param enbled 有效标志位
 */
- (void)setLeftBarButtonItemEnbled:(BOOL)enbled;

#pragma mark 设置右上角按键是否有效点击
/**
 *  设置右上角按键是否有效点击
 *
 *  @param enbled 有效标志位
 */
- (void)setRightBarButtonItemEnbled:(BOOL)enbled;

@end
