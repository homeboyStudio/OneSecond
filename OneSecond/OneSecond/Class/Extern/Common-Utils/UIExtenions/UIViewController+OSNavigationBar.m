//
//  UIViewController+OSNavigationBar.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "UIViewController+OSNavigationBar.h"
#import "OSNavigationBar.h"

#define kNavigationBarTitleViewMaxWidth 190
#define kNavigationBarTitleViewMaxHeight 44

@implementation UIViewController (OSNavigationBar)

- (void)setCustomTitle:(NSString *)title
{
    if (title.length == 0) {
        return;
    }
//     = @{NSFontAttributeName:[OSFont navigationBarTitleFont]};
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[OSFont navigationBarTitleFont] forKey:NSFontAttributeName];
    CGFloat width = [title sizeWithAttributes:attribute].width;
    width = (width > kNavigationBarTitleViewMaxWidth) ? kNavigationBarTitleViewMaxWidth : width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, kNavigationBarTitleViewMaxHeight)];
    [titleLabel setFont:[OSFont navigationBarTitleFont]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[OSColor navigationBarTitleColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.titleView = nil;
    self.navigationItem.titleView = titleLabel;
}

- (void)setCustomTitle:(NSString *)title withColor:(UIColor *)color
{
    if (title.length == 0) {
        return;
    }
    NSDictionary *attribute = @{NSFontAttributeName:kNavigationBarTitleFont};
    CGFloat width = [title sizeWithAttributes:attribute].width;
    width = (width > kNavigationBarTitleViewMaxWidth) ? kNavigationBarTitleViewMaxWidth : width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, kNavigationBarTitleViewMaxHeight)];
    [titleLabel setFont:[OSFont navigationBarTitleFont]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:color];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.titleView = nil;
    self.navigationItem.titleView = titleLabel;
}


- (void)setLeftBarButtonItem:(UIBarButtonItem *)item
{
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setLeftBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector
{
    [self setLeftBarButtonItem:[OSNavigationBar createBarButtonItemWithTitle:title target:target action:selector]];
}

- (void)setLeftBarButtonWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)selector
{
    [self setLeftBarButtonItem:[OSNavigationBar createBarButtonItemWithTitle:title textColor:color target:target action:selector]];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item
{
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)selector
{
    [self setRightBarButtonItem:[OSNavigationBar createBarButtonItemWithTitle:title target:target action:selector]];
}

- (void)setRightBarButtonWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target action:(SEL)selector
{
    [self setRightBarButtonItem:[OSNavigationBar createBarButtonItemWithTitle:title textColor:color target:target action:selector]];
}

- (void)setBackBarButtonItemHidden:(BOOL)hidden
{
    self.navigationItem.backBarButtonItem.customView.hidden = hidden;
}

- (void)setLeftBarButtonItemHidden:(BOOL)hidden
{
    self.navigationItem.leftBarButtonItem.customView.hidden = hidden;
    
}

- (void)setRightBarButtonItemHidden:(BOOL)hidden
{
    self.navigationItem.rightBarButtonItem.customView.hidden = hidden;
}


- (void)setLeftBarButtonItemEnbled:(BOOL)enbled
{
    self.navigationItem.leftBarButtonItem.enabled = enbled;
}

- (void)setRightBarButtonItemEnbled:(BOOL)enbled
{
    self.navigationItem.rightBarButtonItem.enabled = enbled;
}


- (void)setBackBarButtonWithTarget:(id)target action:(SEL)selector
{
    CGFloat barItemMargin;
    if (IOS_7_OR_LATER())
    {
        barItemMargin = 0.0f;
    }
    else
    {
        barItemMargin = 22.0f;
    }
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"btn_back_arrow.png"];
    UIImage* pressedImage = [UIImage imageNamed:@"btn_back_arrow_focus.png"];
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton setImage:pressedImage forState:UIControlStateHighlighted];
    [customButton setFrame:CGRectMake(0, 0, 22 + barItemMargin, 44)];
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    [self setBackBarButtonItem:[OSNavigationBar createBarButtonItemWithCustomView:customButton]];
    [self setLeftBarButtonItem:[OSNavigationBar createBarButtonItemWithCustomView:customButton]];
}

@end
