//
//  OSColor.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

/** RGB颜色 */
#define OSColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define OSColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/** HEX颜色 */
#define OSColorHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]
#define OSColorHexA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:(a)]


#import <Foundation/Foundation.h>

@interface OSColor : NSObject

#pragma mark - Default colors

/*
*   薄荷绿色
*/
+ (UIColor *)mintGreenColor;

+ (UIColor *)skyBlueColor;          // NextDay

+ (UIColor *)specialGaryColor;      // Retrica 灰色

+ (UIColor *)specialorangColor;     // Retrica 橙色

+ (UIColor *)specialRedColor;       //

+ (UIColor *)nextDayGaryColor;

+ (UIColor *)specialDarkColor;   
/*
*     深灰色
*/
+ (UIColor *)grayDarkColor;

/*
 *     纯黑色
 */
+ (UIColor *)pureDarkColor;

/**
 *  白色
 */
+ (UIColor *)pureWhiteColor;

/**
 *  导航栏标题颜色，用于重要级文字，内页标题信息
 */
+ (UIColor *)navigationBarTitleColor;


/**
 *  标题文本颜色，颜色同navigationBarTitleColor，导航栏标题颜色，用于重要级文字，内页标题信息，白色
 */
+ (UIColor *)titleTextColor;

+ (UIColor *)loveColor;
/**
 * 16进制
 */
+ (UIColor *)colorFromHex:(NSString *)hexValue alpha:(CGFloat)alpha;

/**
 *  默认背景颜色，一些浅色背景色（右滑背景，设置页面的一些背景图）
 */
+ (UIColor *)defaultBackgroundColor;

/**
 *  导航栏背景颜色
 */
+ (UIColor *)navigationBarBackgroundColor;

/**
 *  深绿色 C4，用于极少数地方，扫描线，手势密码设置
 */
+ (UIColor *)darkGreenColor;

/**
 *  浅绿色 C3
 */
+ (UIColor *)lightGreenColor;

/**
 *  红色  C5，用于删除按钮、消息未读、错误信息提示等
 */
+ (UIColor *)redColor;



/**
 *   普通按钮、一般按钮，用在按钮深色背景下高亮状态的文本颜色
 */
+ (UIColor *)buttonSelectedTextColor;

/**
 *  次要文本颜色
 */
+ (UIColor *)detailTextColor;

/**
 *  默认文本颜色，用于一些次要信息、或者placehold的信息
 */
+ (UIColor *)placeholderTextColor;

/**
 *  白色文本的占位颜色，透明度0.3，用于深颜色背景下textField的placeHolder颜色
 *  例如：[_textFiled setValue:[OSColor deepPlaceholderTextColor] forKeyPath:@"_placeholderLabel.textColor"];
 */
+ (UIColor *)deepPlaceholderTextColor;

/**
 *  线条颜色，同placeholderTextColor
 */
+ (UIColor *)lineColor;

/**
 *  灰色文字颜色
 *  #9463b5
 */
+ (UIColor *)grayColor;

/**
 *  用于列表类的标题，或一些说明性的内容文字
 */
+ (UIColor *)tableTitleTextColor;

/**
 *  获得10种渐变颜色(暂时先写固定数据在这里面)
 */
+ (NSMutableArray *)getGrandColor;


+ (NSMutableArray *)getGrandColor:(int)count;

@end
