//
//  OSNavigationBar.m
//  OneSecond
//
//  Created by JunhuaRao on 15/10/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSNavigationBar.h"

@implementation OSNavigationBar

+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if (!title) {
        return nil;
    }
    CGFloat barItemMargin;
    if (IOS_7_OR_LATER()) {
        barItemMargin = 0.f;
    }else{
        barItemMargin = 11.f;
    }
    NSDictionary *attribute = @{NSFontAttributeName:kNavigationBarButtonFont};
    CGFloat width = [title sizeWithAttributes:attribute].width + barItemMargin;
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton.titleLabel setFont:kNavigationBarButtonFont];
    
    [customButton setTitleColor:kNavigationBarButtonNormalColor forState:UIControlStateNormal];
    [customButton setTitleColor:kNavigationBarButtonHighlightColor forState:UIControlStateHighlighted];
    [customButton setTitleColor:kNavigationBarButtonDisableColor forState:UIControlStateDisabled];
    
    [customButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
    [customButton setFrame:CGRectMake(0, 0, width+5, 44)];
    [customButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [OSNavigationBar createBarButtonItemWithCustomView:customButton];
}

+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)action
{
    if (!title) {
        return nil;
    }
    
    CGFloat barItemMargin;
    if (IOS_7_OR_LATER()) {
        barItemMargin = 0.f;
    }else{
        barItemMargin = 11.f;
    }
    NSDictionary *attribute = @{NSFontAttributeName:kNavigationBarButtonFont};
    CGFloat width = [title sizeWithAttributes:attribute].width + barItemMargin;
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton.titleLabel setFont:kNavigationBarButtonFont];
    
    [customButton setTitleColor:color forState:UIControlStateNormal];
    //    [customButton setTitleColor:kNavigationBarButtonHighlightColor forState:UIControlStateHighlighted];
    [customButton setTitleColor:kNavigationBarButtonDisableColor forState:UIControlStateDisabled];
    
    [customButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
    [customButton setFrame:CGRectMake(0, 0, width+5, 44)];
    [customButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [OSNavigationBar createBarButtonItemWithCustomView:customButton];
}

+ (UIBarButtonItem *)createBarButtonItemWithCustomView:(UIView *)view
{
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+ (UIBarButtonItem *)createBarButtonItemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:style target:target action:action];
    return item;
}

+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
    return item;
}

@end
