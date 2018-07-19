//
//  OSDevice.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEVICE_WIDTH    [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define SYSKEYBOARD_HEIGHT     216.f
#define SYSKEYBOARD_HEIGHT_6p  226.f

BOOL isIphone5(void);
BOOL isIphone6(void);
BOOL isIphone6Plus(void);
BOOL isRetina(void);
BOOL IOS_5_OR_LATER(void);
BOOL IOS_6_OR_LATER(void);
BOOL IOS_7_OR_LATER(void);
BOOL IOS_8_OR_LATER(void);
BOOL IOS_9_OR_LATER(void);

@interface OSDevice : NSObject

/**
 *  判断是否是iPhone4s
 */
+ (BOOL)isDeviceIPhone4s;

/**
 *  判断是否是iPhone5
 */
+ (BOOL)isDeviceIPhone5;

/**
 *  判断是否是iPhone6
 */
+ (BOOL)isDeviceIPhone6;

/**
 *  判断是否是iPhone6Plus
 */
+ (BOOL)isDeviceIPhone6Plus;

/**
 *  判断是否是Retina设备
 */
+ (BOOL)isDeviceRetina;

/**
 * app name
 */
+ (NSString *)appName;

/**
 *  获取版本型号
 */
+ (NSString *)deviceString;

/**
 *  获取系统版本号
 */
+ (NSString *)iOSVersion;

/**
 *  获取App Version号和Build号
 */
+ (NSString *)appVersion;
+ (NSString *)appVersionAndBuild;


@end
