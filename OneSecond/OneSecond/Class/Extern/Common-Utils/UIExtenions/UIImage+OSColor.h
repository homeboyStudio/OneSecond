//
//  UIImage+OSColor.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OSColor)

+ (UIImage *)imageFromColor:(UIColor *)color;

/*
 * 通过UIColor来绘制
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

@end
