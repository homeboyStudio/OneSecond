//
//  OSDateUtil.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSDateUtil.h"
#import "NSString+Check.h"

// 日历使用到的时区信息
#define kPierCalendarTimeZone_CN   @"Asia/Shanghai"
#define kPierCalendarTimeZone_GMT  @"GMT"

@implementation OSDateUtil

+ (NSString *)storageTimeZone
{
    return kPierCalendarTimeZone_GMT;
}

+ (NSString *)displayTimeZone
{
    return kPierCalendarTimeZone_CN;
}

+ (NSString *)SIMPLEFORMATTYPESTRING1;
{
    return SIMPLEFORMATTYPESTRING1;
}

+ (NSString *)SIMPLEFORMATTYPESTRING2;
{
    return SIMPLEFORMATTYPESTRING2;
}

+ (NSString *)SIMPLEFORMATTYPESTRING3;
{
    return SIMPLEFORMATTYPESTRING2;
}

+ (NSString *)SIMPLEFORMATTYPESTRING4;
{
    return SIMPLEFORMATTYPESTRING4;
}

+ (NSString *)SIMPLEFORMATTYPESTRING5;
{
    return SIMPLEFORMATTYPESTRING5;
}

+ (NSString *)SIMPLEFORMATTYPESTRING6;
{
    return SIMPLEFORMATTYPESTRING6;
}

+ (NSString *)SIMPLEFORMATTYPESTRING7;
{
    return SIMPLEFORMATTYPESTRING7;
}

+ (NSString *)SIMPLEFORMATTYPESTRING8;
{
    return SIMPLEFORMATTYPESTRING8;
}

+ (NSString *)SIMPLEFORMATTYPESTRING9;
{
    return SIMPLEFORMATTYPESTRING9;
}
+ (NSString *)SIMPLEFORMATTYPESTRING10;
{
    return SIMPLEFORMATTYPESTRING10;
}
+ (NSString *)SIMPLEFORMATTYPESTRING11;
{
    return SIMPLEFORMATTYPESTRING11;
}
+ (NSString *)SIMPLEFORMATTYPESTRING12;
{
    return SIMPLEFORMATTYPESTRING12;
}

+ (NSString *)SIMPLEFORMATTYPESTRING13;
{
    return SIMPLEFORMATTYPESTRING13;
}

+ (NSString *)SIMPLEFORMATTYPESTRING14
{
    return SIMPLEFORMATTYPESTRING14;
}

#pragma mark 获取时间
+ (NSDate *)getCurrentDate
{
    NSDate *nowLocalDate = [NSDate date];
    return nowLocalDate;
}

#pragma mark - ----------获取当前日期信息----------

+ (NSString *)getCurrentLogTime
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:SIMPLEFORMATTYPESTRING17];
    NSString *string=[dateFormater stringFromDate:[OSDateUtil getCurrentDate]];
    return string;
}

#pragma mark 获取当前日期 yyyyMMddHHmmss 14位
+ (NSString *)getCurrentTime
{
    NSDate *date = [OSDateUtil getCurrentDate];
    NSDateFormatter *dateFormater = [OSDateUtil getCurrentDateFormatter];
    [dateFormater setDateFormat:SIMPLEFORMATTYPESTRING1];
    
    return [OSDateUtil getStringDate:date formatType:SIMPLEFORMATTYPE1];
}

+ (long)getTimestamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp=[date timeIntervalSince1970];
    long timestamp_i = ceil(timestamp);
    return timestamp_i;
}

#pragma mark 将日期字串转为日期对象,dateStr需超过8位且不能为空,否则返回nil
+ (NSDate *)getDateByDateStr:(NSString *)dateStr
{
    if(dateStr == nil || dateStr.length < 8)
    {
        return nil;
    }
    
    NSDate *date = nil;
    
    if(dateStr.length == 8)
    {
        date = [OSDateUtil dateFromString:dateStr formate:@"yyyyMMdd"];
    }else if(dateStr.length == 10)
    {
        date = [OSDateUtil dateFromString:dateStr formate:@"yyyyMMddHH"];
    }else if(dateStr.length == 12)
    {
        date = [OSDateUtil dateFromString:dateStr formate:@"yyyyMMddHHmm"];
    }else if(dateStr.length == 14)
    {
        date = [OSDateUtil dateFromString:dateStr formate:@"yyyyMMddHHmmss"];
    }
    
    return date;
}

#pragma mark 日期字符串转换为日期对象
+ (NSDate *)dateFromString:(NSString *)dateString formate:(NSString *)formate
{
    NSDateFormatter *dateFormater = [OSDateUtil getCurrentDateFormatter];
    
    if(formate == nil || [formate isEqualToString:@""])
    {
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
    }else
    {
        [dateFormater setDateFormat:formate];
    }
    NSDate *retDate = [dateFormater dateFromString:dateString];
    
    if (!retDate) {
        NSTimeZone *displayTimeZone = [NSTimeZone timeZoneWithName:[OSDateUtil displayTimeZone]];
        NSTimeZone *storageTimeZone = [NSTimeZone timeZoneWithName:[OSDateUtil storageTimeZone]];
        
        [dateFormater setTimeZone:storageTimeZone];
        retDate = [dateFormater dateFromString:dateString];
        NSInteger intervalSeconds = [displayTimeZone secondsFromGMT];
        retDate = [retDate dateByAddingTimeInterval:-intervalSeconds];
    }
    
    
    return retDate;
}

#pragma mark 获取当前日期格式器
+ (NSDateFormatter *)getCurrentDateFormatter
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithName:[OSDateUtil displayTimeZone]]];
    
    return dateFormater;
}

#pragma mark 根据 SimpleDateFormatType类型将calendar转成对应的格式 如果date为null则返回空字符串
+ (NSString *)getStringDate:(NSDate *)date formatType:(SIMPLEFORMATTYPE)SimpleDateFormatType
{
    NSString *str = @"";
    NSString *type = @"";
    switch (SimpleDateFormatType)
    {
        case SIMPLEFORMATTYPE1:
            type = SIMPLEFORMATTYPESTRING1;
            break;
        case SIMPLEFORMATTYPE2:
            type = SIMPLEFORMATTYPESTRING2;
            break;
        case SIMPLEFORMATTYPE3:
            type = SIMPLEFORMATTYPESTRING3;
            break;
        case SIMPLEFORMATTYPE4:
            type = SIMPLEFORMATTYPESTRING4;
            break;
        case SIMPLEFORMATTYPE5:
            type = SIMPLEFORMATTYPESTRING5;
            break;
        case SIMPLEFORMATTYPE6:
            type = SIMPLEFORMATTYPESTRING6;
            break;
        case SIMPLEFORMATTYPE7:
            type = SIMPLEFORMATTYPESTRING7;
            break;
        case SIMPLEFORMATTYPE8:
            type = SIMPLEFORMATTYPESTRING8;
            break;
        case SIMPLEFORMATTYPE9:
            type = SIMPLEFORMATTYPESTRING9;
            break;
        case SIMPLEFORMATTYPE10:
            type = SIMPLEFORMATTYPESTRING10;
            break;
        case SIMPLEFORMATTYPE11:
            type = SIMPLEFORMATTYPESTRING11;
            break;
        case SIMPLEFORMATTYPE12:
            type = SIMPLEFORMATTYPESTRING12;
            break;
        case SIMPLEFORMATTYPE13:
            type = SIMPLEFORMATTYPESTRING13;
            break;
        case SIMPLEFORMATTYPE14:
            type = SIMPLEFORMATTYPESTRING14;
            break;
        case SIMPLEFORMATTYPE15:
            type = SIMPLEFORMATTYPESTRING15;
            break;
        case SIMPLEFORMATTYPE16:
            type = SIMPLEFORMATTYPESTRING16;
            break;
        case SIMPLEFORMATTYPE17:
            type = SIMPLEFORMATTYPESTRING17;
            break;
        case SIMPLEFORMATTYPE18:
            type = SIMPLEFORMATTYPESTRING18;
            break;
        case SIMPLEFORMATTYPE19:
            type = SIMPLEFORMATTYPESTRING18;
            break;
        default:
            type = SIMPLEFORMATTYPESTRING1;
            break;
    }
    
    
    if (type != nil && type.length != 0 && date != nil)
    {
        NSDateFormatter *dateFormater = [OSDateUtil getCurrentDateFormatter];
        [dateFormater setDateFormat:type];
        str = [dateFormater stringFromDate:date];
    }
    
    return str;
}

+ (NSString *)getStringFormateDate:(NSDate *)date
                        formatType:(NSString *)formate{
    NSString *str = @"";
    NSString *type = formate;
    
    if (type != nil && type.length != 0 && date != nil)
    {
        NSDateFormatter *dateFormater = [OSDateUtil getCurrentDateFormatter];
        [dateFormater setDateFormat:type];
        str = [dateFormater stringFromDate:date];
    }
    
    return str;
}

+ (NSString *)getStringTimeByTimeStamp:(long long)timestamp formate:(NSString *)formate{
    NSString *result = @"";
    
    if (timestamp!=0) {
        NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
        result = [OSDateUtil getStringFormateDate:date formatType:formate];
    }else{
        result = @"";
    }
    
    return result;
}

+ (NSString *)getStringTimeByServiceFormate:(NSString *)time formate:(NSString *)formate{
    NSString *result = @"";
    
    if (![NSString emptyOrNull:time]) {
        NSDate *date = [OSDateUtil dateFromString:time formate:SIMPLEFORMATTYPESTRING1];
        result = [OSDateUtil getStringFormateDate:date formatType:formate];
    }else{
        result = @"暂无";
    }
    
    return result;
}

+ (NSInteger)calculateAgeWithBirthdate:(NSDate *)birthdate
{
    return [OSDateUtil calculateAgeWithBirthdate:birthdate toNowDate:[OSDateUtil getCurrentDate]];
}

+ (NSInteger)calculateAgeWithBirthdate:(NSDate *)birthdate toNowDate:(NSDate *)nowDate
{
    NSInteger ageResult = 0;
    
    NSCalendar *calendar = [OSDateUtil getCurrentCalendar];
    NSDateComponents *ageDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:birthdate toDate:nowDate options:0];
    ageResult = ageDateComponents.year;
    
    return ageResult;
}

#pragma mark 获取当前日历
+ (NSCalendar *)getCurrentCalendar
{
    NSCalendar *calendar_ = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar_ setFirstWeekday:1];
    [calendar_ setLocale:[[NSLocale alloc] initWithLocaleIdentifier:kPierCalendarTimeZone_CN]];
    [calendar_ setMinimumDaysInFirstWeek:1];
    [calendar_ setTimeZone:[NSTimeZone timeZoneWithName:kPierCalendarTimeZone_CN]];
    
    return calendar_;
}

#pragma mark 获得月份
+ (NSString *)getMonthStringWithDate:(NSString *)date
{
    NSInteger month = [[date substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSString *monthSting = [NSString stringWithFormat:@"%ld",(long)month];
//    switch (month) {
//        case 1: {
//            monthSting = @"1月";
//            break;
//        }
//        case 2: {
//            monthSting = @"2月";
//            break;
//        }
//        case 3: {
//             monthSting = @"3月";
//            break;
//        }
//        case 4: {
//             monthSting = @"4月";
//            break;
//        }
//        case 5: {
//             monthSting = @"5月";
//            break;
//        }
//        case 6: {
//             monthSting = @"6月";
//            break;
//        }
//        case 7: {
//             monthSting = @"7月";
//            break;
//        }
//        case 8: {
//             monthSting = @"8月";
//            break;
//        }
//        case 9: {
//             monthSting = @"9月";
//            break;
//        }
//        case 10: {
//             monthSting = @"10月";
//            break;
//        }
//        case 11: {
//             monthSting = @"11月";
//            break;
//        }
//        case 12: {
//             monthSting = @"12月";
//            break;
//        }
//        default:
//            break;
//    }
    
    return monthSting;
}

#pragma mark 获取当前月份和年
+ (NSString *)getMonthAndYearStringWithDate:(NSString *)date
{
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [date substringWithRange:NSMakeRange(4, 2)];
    NSString *monthSting = @"";
        switch ([month integerValue]) {
            case 1: {
                monthSting = @"JANUARY";  // JANUARY  January  JAN.
                break;
            }
            case 2: {
                monthSting = @"FEBRUARY"; // FEBRUARY  February  FEB.
                break;
            }
            case 3: {
                 monthSting = @"MARCH";   // MARCH   March   MAR.
                break;
            }
            case 4: {
                 monthSting = @"APRIL";   // APRIL  April  APR.
                break;
            }
            case 5: {
                 monthSting = @"MAY";     // MAY  May  MAY.
                break;
            }
            case 6: {
                 monthSting = @"JUNE";   // JUNE  June  JUN.
                break;
            }
            case 7: {
                 monthSting = @"JULY";   // JULY  July  JUL.
                break;
            }
            case 8: {
                 monthSting = @"AUGUST"; // AUGUST  August  AUG.
                break;
            }
            case 9: {
                 monthSting = @"SEPTEMBER"; // SEPTEMBER  September  SEP.
                break;
            }
            case 10: {
                 monthSting = @"OCTOBER";   // OCTOBER  October  OCT.
                break;
            }
            case 11: {
                 monthSting = @"NOVEMBER";  // NOVEMBER  November  NOV.
                break;
            }
            case 12: {
                 monthSting = @"DECEMBER";  // DECEMBER  December  DEC.
                break;
            }
            default:
                break;
        }

    return [NSString stringWithFormat:@"%@ %@, %@",monthSting,month,year];
}

#pragma mark 获取当前月份和年
+ (NSString *)getWatemarkDateWithDate:(NSString *)date
{
    NSArray *monthArray = @[@"JANUARY",@"FEBRUARY",@"MARCH",@"APRIL",@"MAY",@"JUNE",@"JULY",@"AUGUST",@"SEPTEMBER",@"OCTOBER",@"NOVEMBER",@"DECEMBER"];
    
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [date substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [date substringWithRange:NSMakeRange(6, 2)];
    
    month = monthArray[(month.integerValue - 1)];
    switch (day.integerValue) {
        case 1:
        {
            day = [NSString stringWithFormat:@"%ldst",(long)day.integerValue];
            break;
        }
        case 2:
        {
            day = [NSString stringWithFormat:@"%ldnd",(long)day.integerValue];
            break;
        }
        case 3:
        {
            day = [NSString stringWithFormat:@"%ldrd",(long)day.integerValue];
            break;
        }
         case 21:
        {
             day = [NSString stringWithFormat:@"%ldst",(long)day.integerValue];
            break;
        }
        case 22:
        {
            day = [NSString stringWithFormat:@"%ldnd",(long)day.integerValue];
            break;
        }
        case 23:
        {
            day = [NSString stringWithFormat:@"%ldrd",(long)day.integerValue];
            break;
        }
        case 31:
        {
            day = [NSString stringWithFormat:@"%ldst",(long)day.integerValue];
            break;
        }
        default:
        {
             day = [NSString stringWithFormat:@"%ldth",(long)day.integerValue];
            break;
        }
    }
    
    
    return [NSString stringWithFormat:@"%@ %@, %@",month, day, year];
}

@end
