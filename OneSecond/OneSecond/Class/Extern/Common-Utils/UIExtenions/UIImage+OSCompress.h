//
//  UIImage+OSCompress.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
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
