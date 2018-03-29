//
//  UINavigationController+OSExtension.h
//  OneSecond
//
//  Created by JHR on 15/10/21.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (OSExtension)

@property (nonatomic, assign) BOOL fullScreenInteractivePopGestureRecognizer NS_AVAILABLE_IOS(7_0); // If YES, then you can have a fullscreen
/// gesture recognizer responsible for popping the top view controller off the navigation stack, and the property is still
/// "interactivePopGestureRecognizer", see more for "UINavigationController.h", Default is NO.

@property (nonatomic, assign) CGFloat navigationBarBackgroundAlpha NS_AVAILABLE_IOS(7_0); // navigationBar's background alpha, when 0 your
/// navigationBar will be invisable, default is 1. Animatable

@end
