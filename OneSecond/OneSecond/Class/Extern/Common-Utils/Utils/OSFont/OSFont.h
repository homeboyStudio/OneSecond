//
//  OSFont.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSFont : NSObject

/**
 *  导航栏字体
 */
+ (UIFont *)navigationBarTitleFont;

/**
 *  自定义字体
 */
+ (UIFont *)customFontWithSize:(CGFloat)size;

+ (UIFont *)customBoldFontWithSize:(CGFloat)size;

/**
 * NextDay  字体
 */
+ (UIFont *)nextDayThinFontWithSize:(CGFloat)size;

+ (UIFont *)nextDayFontWithSize:(CGFloat)size;

/**
 *  自定义数字字体
 */
+ (UIFont *)customNumberFontWithSize:(CGFloat)size;


@end
