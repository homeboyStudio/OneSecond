//
//  UIImage+OSColor.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "UIImage+OSColor.h"

@implementation UIImage (OSColor)

+ (UIImage *)imageFromColor:(UIColor *)color
{
    return [[self imageFromColor:color size:CGSizeMake(1, 1)]
            resizableImageWithCapInsets:UIEdgeInsetsZero];
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, bounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
