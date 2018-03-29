//
//  OSDateUtil.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    SIMPLEFORMATTYPE1  = 1,
    SIMPLEFORMATTYPE2  = 2,
    SIMPLEFORMATTYPE3  = 3,
    SIMPLEFORMATTYPE4  = 4,
    SIMPLEFORMATTYPE5  = 5,
    SIMPLEFORMATTYPE6  = 6,
    SIMPLEFORMATTYPE7  = 7,
    SIMPLEFORMATTYPE8  = 8,
    SIMPLEFORMATTYPE9  = 9,
    SIMPLEFORMATTYPE10 = 10,
    SIMPLEFORMATTYPE11 = 11,
    SIMPLEFORMATTYPE12 = 12,
    SIMPLEFORMATTYPE13 = 13,
    SIMPLEFORMATTYPE14 = 14,
    SIMPLEFORMATTYPE15 = 15,
    SIMPLEFORMATTYPE16 = 16,
    SIMPLEFORMATTYPE17 = 17,
    SIMPLEFORMATTYPE18 = 18,
    SIMPLEFORMATTYPE19,
}SIMPLEFORMATTYPE;

/**
 * ********************SIMPLEFORMATTYPE对应的字串*********************
 */
/**
 * SIMPLEFORMATTYPE1 对应类型：yyyyMMddHHmmss
 */
static NSString *SIMPLEFORMATTYPESTRING1 = @"yyyyMMddHHmmss";

/**
 * SIMPLEFORMATTYPE2 对应的类型：yyyy-MM-dd HH:mm:ss
 */
static NSString *SIMPLEFORMATTYPESTRING2 = @"yyyy-MM-dd HH:mm:ss";

/**
 * SIMPLEFORMATTYPE3 对应的类型：yyyy-M-d HH:mm:ss
 */
static NSString *SIMPLEFORMATTYPESTRING3 = @"yyyy-M-d HH:mm:ss";

/**
 * SIMPLEFORMATTYPE4对应的类型：yyyy-MM-dd HH:mm
 */
static NSString *SIMPLEFORMATTYPESTRING4 = @"yyyy-MM-dd HH:mm";

/**
 * SIMPLEFORMATTYPE5 对应的类型：yyyy-M-d HH:mm
 */
static NSString *SIMPLEFORMATTYPESTRING5 = @"yyyy-M-d HH:mm";

/**
 * SIMPLEFORMATTYPE6对应的类型：yyyyMMdd
 */
static NSString *SIMPLEFORMATTYPESTRING6 = @"yyyyMMdd";

/**
 * SIMPLEFORMATTYPE7对应的类型：yyyy-MM-dd
 */
static NSString *SIMPLEFORMATTYPESTRING7 = @"yyyy-MM-dd";

/**
 * SIMPLEFORMATTYPE8对应的类型： yyyy-M-d
 */
static NSString *SIMPLEFORMATTYPESTRING8 = @"yyyy-M-d";

/**
 * SIMPLEFORMATTYPE9对应的类型：yyyy年MM月dd日
 */
static NSString *SIMPLEFORMATTYPESTRING9 = @"yyyy年MM月dd日";

/**
 * SIMPLEFORMATTYPE10对应的类型：yyyy年M月d日
 */
static NSString *SIMPLEFORMATTYPESTRING10 = @"yyyy年M月d日";

/**
 * SIMPLEFORMATTYPE11对应的类型：M月d日
 */
static NSString *SIMPLEFORMATTYPESTRING11 = @"M月d日";

/**
 * SIMPLEFORMATTYPE12对应的类型：HH:mm:ss
 */
static NSString *SIMPLEFORMATTYPESTRING12 = @"HH:mm:ss";

/**
 * SIMPLEFORMATTYPE13对应的类型：HH:mm
 */
static NSString *SIMPLEFORMATTYPESTRING13 = @"HH:mm";
/**
 * SIMPLEFORMATTYPE7对应的类型：yyyy-MM-dd
 */
static NSString *SIMPLEFORMATTYPESTRING14 = @"yyyy/MM/dd";

/***
 * SIMPLEFORMATTYPE15对应的类型：yyyy年MM月
 */

static NSString *SIMPLEFORMATTYPESTRING15 = @"yyyy年MM月";

/***
 * SIMPLEFORMATTYPE16对应的类型：yyyyMMddHHmmssSSS
 */

static NSString *SIMPLEFORMATTYPESTRING16 = @"yyyyMMddHHmmssSSS";

/***
 * SIMPLEFORMATTYPE17对应的类型：yyyy-MM-dd HH:mm:ss.SSS
 */

static NSString *SIMPLEFORMATTYPESTRING17 = @"yyyy-MM-dd HH:mm:ss.SSS";

/**
 * SIMPLEFORMATTYPESTRING18 对应类型：yyyy/MM/dd HH:mm:ss
 */
static NSString *SIMPLEFORMATTYPESTRING18 = @"yyyy/MM/dd HH:mm:ss";

/**
 * SIMPLEFORMATTYPESTRING19 对应类型：MM/dd/yyyy HH:mm:ss
 */
static NSString *SIMPLEFORMATTYPESTRING19 = @"MM/dd/yyyy HH:mm:ss";

/**
 * SIMPLEFORMATTYPESTRING20 对应类型：MM-dd
 */
static NSString *SIMPLEFORMATTYPESTRING20 = @"MM-dd";

/**
 * SIMPLEFORMATTYPESTRING21 对应类型：M-d
 */
static NSString *SIMPLEFORMATTYPESTRING21 = @"M.d";

/** 日期工具类 */
@interface OSDateUtil : NSObject

/**
	时间存储时区，默认GMT+00
	@return 时区字符串
 */
+ (NSString *)storageTimeZone;

/**
 时间显示时区，默认GMT+08
 @return 时区字符串
 */
+ (NSString *)displayTimeZone;

/**
 获取当前日期 date
 @return 时间字符串
 */
+ (NSDate *)getCurrentDate;

/**
 将日期字串转为日期对象,dateStr需超过8位且不能为空,否则返回nil
 @param dateStr 日期字符串
 @return 日期对象
 */
+ (NSDate *)getDateByDateStr:(NSString *)dateStr;

/**
 日期字符串转换为日期对象
 @param str 日期字符串
 @param formate 字符串格式，默认格式yyyy-MM-dd
 @return 日期对象
 */
+ (NSDate *)dateFromString:(NSString *)str
                   formate:(NSString *)formate;

/**
 根据 SimpleDateFormatType类型将calendar转成对应的格式 如果date为null则返回空字符串
 
 @param date 日起对象
 @param SimpleDateFormatType 需要转换的格式类型
 @return 格式化的日期字符串
 */
+ (NSString *)getStringDate:(NSDate *)date
                 formatType:(SIMPLEFORMATTYPE)SimpleDateFormatType;

+ (NSString *)getStringFormateDate:(NSDate *)date
                        formatType:(NSString *)formate;

/**
 获取当前日期 yyyy-MM-dd HH:mm:ss.SSS
 @return 时间字符串
 */
+ (NSString *)getCurrentLogTime;

/**
 获取当前日期 yyyyMMddHHmmss 14位
 @return 时间字符串
 */
+ (NSString *)getCurrentTime;

/**
 获取当前时间戳
 @return
 */
+ (long)getTimestamp;

/**
 时间戳转换成stirng
 */
+ (NSString *)getStringTimeByTimeStamp:(long long)timestamp formate:(NSString *)formate;

/**
 服务器格式yyyyMMddHHmmss
 */
+ (NSString *)getStringTimeByServiceFormate:(NSString *)time formate:(NSString *)formate;

/**
 * 计算生日
 */
+ (NSInteger)calculateAgeWithBirthdate:(NSDate *)birthdate;

#pragma mark ------------------ 日期转换 ---------------
/**
 *   date: 20150119
 */
+ (NSString *)getMonthStringWithDate:(NSString *)date;

#pragma mark 获取当前月份和年
+ (NSString *)getMonthAndYearStringWithDate:(NSString *)date;

#pragma mark 获取当前月份和年
+ (NSString *)getWatemarkDateWithDate:(NSString *)date;

@end
