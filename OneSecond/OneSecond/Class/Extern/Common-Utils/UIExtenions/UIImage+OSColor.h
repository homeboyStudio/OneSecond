//
//  UIImage+OSColor.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OSColor)

+ (UIImage *)imageFromColor:(UIColor *)color;

/*
 * 通过UIColor来绘制
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

@end
