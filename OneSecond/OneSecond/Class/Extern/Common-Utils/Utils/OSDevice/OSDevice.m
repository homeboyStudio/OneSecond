//
//  OSDevice.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSDevice.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>

#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <net/if.h>
#import "NSString+Check.h"

double IPHONE_OS_MAIN_VERSION() {
    static double __iphone_os_main_version = 0.0;
    if(__iphone_os_main_version == 0.0) {
        NSString *sv = [[UIDevice currentDevice] systemVersion];
        NSScanner *sc = [[NSScanner alloc] initWithString:sv];
        if(![sc scanDouble:&__iphone_os_main_version])
            __iphone_os_main_version = -1.0;
    }
    return __iphone_os_main_version;
}

BOOL isIphone4s()
{
    return [OSDevice isDeviceIPhone4s];
}

BOOL isIphone5()
{
    return [OSDevice isDeviceIPhone5];
}

BOOL isIphone6()
{
    return [OSDevice isDeviceIPhone6];
}

BOOL isIphone6Plus()
{
    return [OSDevice isDeviceIPhone6Plus];
}

BOOL isRetina()
{
    return [OSDevice isDeviceRetina];
}

BOOL IOS_5_OR_LATER() {
    return IPHONE_OS_MAIN_VERSION() >= 5.0;
}

BOOL IOS_6_OR_LATER() {
    return IPHONE_OS_MAIN_VERSION() >= 6.0;
}

BOOL IOS_7_OR_LATER() {
    return IPHONE_OS_MAIN_VERSION() >= 7.0;
}

BOOL IOS_8_OR_LATER() {
    return IPHONE_OS_MAIN_VERSION() >= 8.0;
}

BOOL IOS_9_OR_LATER() {
    return IPHONE_OS_MAIN_VERSION() >= 9.0;
}

@implementation OSDevice

#pragma mark 判断是否iphone5

+ (BOOL)isDeviceIPhone4s
{
    if (((unsigned int) DEVICE_HEIGHT) == 480)  { return YES;}
    return [[OSDevice deviceString] isEqualToString:@"iPhone 4S"];
}

+ (BOOL)isDeviceIPhone5
{
    if (((unsigned int)DEVICE_HEIGHT) == 568) { return YES; }
    
    return ([[OSDevice deviceString] isEqualToString:@"iPhone 5"]);
}

+ (BOOL)isDeviceIPhone6
{
    if (((unsigned int)DEVICE_HEIGHT) == 667) { return YES; }
    
    return ([[OSDevice deviceString] isEqualToString:@"iPhone 6"]);
}

+ (BOOL)isDeviceIPhone6Plus
{
    if (((unsigned int)DEVICE_HEIGHT) == 736) { return YES; }
    
    return ([[OSDevice deviceString] isEqualToString:@"iPhone 6 Plus"]);
}

#pragma mark 判断是否是Retina设备

+ (BOOL)isDeviceRetina
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 获取系统版本号
+ (NSString *)iOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 * app name
 */
+ (NSString *)appName{
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if ([NSString emptyOrNull:name]) {
        name = @"一秒";
    }
    return name;
}

#pragma mark --- 获取App版本信息
// 获取APP版本号
+ (NSString *)appVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([NSString emptyOrNull:version]) {
        version = @"0";
    }
    return version;
}

// 获取APP build号
+ (NSString *)appBuild
{
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if ([NSString emptyOrNull:build]) {
        build = @"0";
    }
    return build;
}

+ (NSString *)appVersionAndBuild
{
    return [NSString stringWithFormat:@"%@(%@)", [self appVersion], [self appBuild]];
}



#pragma mark 获取版本型号

+ (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
    
//    if([deviceString isEqualToString:@"iPhone1,1"]) {
//        return @"iPhone 1G";
//    }
//    else if([deviceString isEqualToString:@"iPhone1,2"]) {
//        return @"iPhone 3G";
//    }
//    else if([deviceString hasPrefix:@"iPhone2,"]) {
//        return @"iPhone 3GS";
//    }
//    else if([deviceString hasPrefix:@"iPhone3,"]) {
//        return @"iPhone 4";
//    }
//    else if([deviceString hasPrefix:@"iPhone4,"]) {
//        return @"iPhone 4S";
//    }
//    else if([deviceString hasPrefix:@"iPhone5,1"] || [deviceString hasPrefix:@"iPhone5,2"]) {
//        return @"iPhone 5";
//    }
//    else if([deviceString hasPrefix:@"iPhone5,3"] || [deviceString hasPrefix:@"iPhone5,4"]) {
//        return @"iPhone 5c";
//    }
//    else if([deviceString hasPrefix:@"iPhone6,"]) {
//        return @"iPhone 5s";
//    }
//    else if([deviceString hasPrefix:@"iPhone7,2"]) {
//        return @"iPhone 6";
//    }
//    else if([deviceString hasPrefix:@"iPhone7,1"]) {
//        return @"iPhone 6 Plus";
//    }
//    else if([deviceString hasPrefix:@"iPod1,"]) {
//        return @"iPod Touch 1G";
//    }
//    else if([deviceString hasPrefix:@"iPod2,"]) {
//        return @"iPod Touch 2G";
//    }
//    else if([deviceString hasPrefix:@"iPod3,"]) {
//        return @"iPod Touch 3G";
//    }
//    else if([deviceString hasPrefix:@"iPod4,"]) {
//        return @"iPod Touch 4G";
//    }
//    else if([deviceString hasPrefix:@"iPod5,"]) {
//        return @"iPod Touch 5G";
//    }
//    else if([deviceString hasPrefix:@"iPad1,"]) {
//        return @"iPad 1G";
//    }
//    else if([deviceString hasPrefix:@"iPad2,1"]||[deviceString hasPrefix:@"iPad2,2"]||[deviceString hasPrefix:@"iPad2,3"]||[deviceString hasPrefix:@"iPad2,4"]) {
//        return @"iPad 2";
//    }
//    else if([deviceString hasPrefix:@"iPad3,1"]||[deviceString hasPrefix:@"iPad3,2"]||[deviceString hasPrefix:@"iPad3,3"]) {
//        return @"iPad 3";
//    }
//    else if([deviceString hasPrefix:@"iPad3,4"]||[deviceString hasPrefix:@"iPad3,5"]||[deviceString hasPrefix:@"iPad3,6"]) {
//        return @"iPad 4";
//    }
//    else if([deviceString hasPrefix:@"iPad4,1"]||[deviceString hasPrefix:@"iPad4,2"]||[deviceString hasPrefix:@"iPad4,3"]) {
//        return @"iPad Air";
//    }
//    else if([deviceString hasPrefix:@"iPad2,5"]||[deviceString hasPrefix:@"iPad2,6"]||[deviceString hasPrefix:@"iPad2,7"]) {
//        return @"iPad mini 1G";
//    }
//    else if([deviceString hasPrefix:@"iPad4,4"]||[deviceString hasPrefix:@"iPad4,5"]||[deviceString hasPrefix:@"iPad4,6"]) {
//        return @"iPad mini 2G";
//    }
//    else if ([deviceString isEqualToString:@"i386"] || [deviceString isEqualToString:@"x86_64"])
//    {
//        return @"Simulator";
//    }
////    DLog(@"NOTE: Unknown device type: %@", deviceString);
//    
//    return deviceString;
}

@end
