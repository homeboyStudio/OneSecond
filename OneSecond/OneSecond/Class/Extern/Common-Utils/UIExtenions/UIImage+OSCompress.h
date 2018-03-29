//
//  UIImage+OSCompress.h
//  OneSecond
//
//  Created by JunhuaRao on 15/10/30.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OSCompress)
/*
*    压缩UIImage到某个尺寸
*    @param UIImage对象
*    @param 压缩CGsize
*/
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;

/*
 *   等比压缩
 */
+ (UIImage *)imageCompressForSize:(UIImage *)image RateFloat:(CGFloat)rate;

@end