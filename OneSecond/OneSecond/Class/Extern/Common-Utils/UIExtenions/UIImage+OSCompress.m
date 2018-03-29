//
//  UIImage+OSCompress.m
//  OneSecond
//
//  Created by JunhuaRao on 15/10/30.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "UIImage+OSCompress.h"

@implementation UIImage (OSCompress)

+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使用当前的context
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)imageCompressForSize:(UIImage *)image RateFloat:(CGFloat)rate
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    //  需要缩放的比例
    CGFloat targetWidth = width * rate;
    CGFloat targetHeight = height * rate;

    CGSize size = CGSizeMake(targetWidth, targetHeight);
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使用当前的context
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
