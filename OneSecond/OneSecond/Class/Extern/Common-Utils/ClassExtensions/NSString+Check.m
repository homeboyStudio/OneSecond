//
//  NSString+Check.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "NSString+Check.h"
#import "OSDateUtil.h"

@implementation NSString (Check)

+ (BOOL)emptyOrNull:(NSString *)str
{
    return str == nil || (NSNull *)str == [NSNull null] || str.length == 0;
}

+ (NSString *)getUnNilString:(NSString *)str
{
    NSString *result = @"";
    if ([NSString emptyOrNull:str]) {
        result = @"";
    }else{
        result = str;
    }
    return result;
}

+ (BOOL)arrayEmptyOrNull:(NSArray *)array
{
    return array == nil || (NSNull *)array == [NSNull null] || [array count] < 1;
}

- (bool)isNumString
{
    NSString *match=@"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    bool valid = [predicate evaluateWithObject:self];
    return valid;
}

- (bool)isEnString
{
    NSString *match=@"[\\s]*[A-Za-z]+[\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isStringOnlyEnOrNum
{
    NSString *match = @"[A-Za-z0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (bool)isValidCN
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (bool)isValidEmail
{
    NSString *match=@"\\S+@(\\S+\\.)+[\\S]{1,6}";
    //  NSString *match=@"[a-zA-Z0-9_.-]+@([a-zA-Z0-9]+\\.)+[a-zA-Z]{1,6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    bool valid = [predicate evaluateWithObject:self];
    
    return valid;
}

- (eDOBFormate)checkDOBFormate
{
    eDOBFormate result = eDOBFormate_invalid;
    if ([self rangeOfString:@"Y"].location == NSNotFound) {
        NSDate *dobData = [OSDateUtil dateFromString:self formate:SIMPLEFORMATTYPESTRING14];
        NSInteger age = [OSDateUtil calculateAgeWithBirthdate:dobData];
        
        if (dobData) {
            if (age < 18) {
                result = eDOBFormate_less18;
            }else if (age > 120){
                result = eDOBFormate_more120;
            }else{
                result = eDOBFormate_available;
            }
        }else{
            result = eDOBFormate_invalid;
        }
    }else{
        result = eDOBFormate_invalid;
    }
    
    return result;
}

/**
 * 是否是合格的SSN
 */
- (BOOL)isValidSSN
{
    if ([self length]==9) {
        NSMutableString *formateSSN = [[NSMutableString alloc] init];
        [formateSSN appendString:[self substringToIndex:3]];
        NSRange range2 = NSMakeRange(3, 2);
        NSRange range3 = NSMakeRange(5, 4);
        [formateSSN appendFormat:@"-%@-",[self substringWithRange:range2]];
        [formateSSN appendFormat:@"%@",[self substringWithRange:range3]];
        
        NSString *re = @"^(?!219099999|078051120)(?!666|000|9\\d{2})\\d{3}(?!00)\\d{2}(?!0{4})\\d{4}$";
        NSString *reWithDash =@"^(?!\\b(\\d)\1+-(\\d)\\1+-(\\d)\\1+\\b)(?!123-45-6789|219-09-9999|078-05-1120)(?!666|000|9\\d{2})\\d{3}-(?!00)\\d{2}-(?!0{4})\\d{4}$";
        NSPredicate *predicate_re = [NSPredicate predicateWithFormat:@"SELF matches %@", re];
        NSPredicate *predicate_reWithDash = [NSPredicate predicateWithFormat:@"SELF matches %@", reWithDash];
        
        return ([predicate_re evaluateWithObject:formateSSN] || [predicate_reWithDash evaluateWithObject:formateSSN]);
    }else{
        return NO;
    }
}

- (int)strByteLength
{
    if(self == nil || [self isEqualToString:@""])
    {
        return 0;
    }
    
    int len = 0;
    
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (unsigned int i = 0 ; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
    {
        if (*p)
        {
            p++;
            len++;
        }
        else
        {
            p++;
        }
    }
    
    return len;
}

#pragma mark 判断string是否包含aString
- (BOOL)isContainString:(NSString *)subString
{
    NSRange range = [[self lowercaseString] rangeOfString:[subString lowercaseString]];
    return range.location != NSNotFound;
}

- (NSString *)phoneFormat
{
    NSMutableString *phoneFormat = [NSMutableString stringWithString:self];
    switch (self.length) {
        case 10:
        {
            [phoneFormat insertString:@"(" atIndex:0];
            [phoneFormat insertString:@")" atIndex:4];
            [phoneFormat insertString:@"-" atIndex:8];
            break;
        }
        case 11:
        {
            [phoneFormat insertString:@"-" atIndex:3];
            [phoneFormat insertString:@"-" atIndex:8];
            break;
        }
        default:
            break;
    }
    return phoneFormat;
}

- (NSString *)dobFormat
{
    NSMutableString *dobFormat = [NSMutableString stringWithString:self];
    switch (self.length) {
        case 8:
        {
            [dobFormat insertString:@"-" atIndex:4];
            [dobFormat insertString:@"-" atIndex:7];
            break;
        }
        default:
            break;
    }
    return dobFormat;
}

- (NSString *)idNumberFormat
{
    if ([NSString emptyOrNull:self]) return @"";
    
    NSMutableString *idNumberFormat = [NSMutableString stringWithString:self];
    [idNumberFormat replaceCharactersInRange:NSMakeRange(1, self.length-2) withString:@"****"];
    return idNumberFormat;
}

- (NSString *)phoneClearFormat
{
    if ([NSString emptyOrNull:self]) return @"";
    
    NSString *result = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return result;
}

+ (NSString *)getNumbers:(NSString*)stirng
{
    NSUInteger len = [stirng length];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < len; i++) {
        NSString *s = [stirng substringWithRange:NSMakeRange(i, 1)];
        if (![NSString emptyOrNull:s] && [s isNumString]) {
            [resultStr appendString:s];
        }
    }
    return resultStr;
}

+ (NSString *)getAmountFormatterDecimalStyle:(NSString *)number currency:(NSString *)currency
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSLocale *usLocale = nil;
    if ([[currency uppercaseString] isEqualToString:@"USD"]) {
        usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }else if ([[currency uppercaseString] isEqualToString:@"RMB"] || [[currency uppercaseString] isEqualToString:@"CNY"] ){
        usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }else {
        usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    
    [numberFormatter setLocale:usLocale];
    
    NSString *currencyStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]];
    
    NSMutableString *result = [NSMutableString stringWithString:currencyStr];
    if ([result hasPrefix:@"-"]) {
        [result deleteCharactersInRange:NSMakeRange(0, 1)];
        [result insertString:@"-" atIndex:1];
    }
    
    return result;
}

- (BOOL)isValidPassword
{
    BOOL result = NO;
    if (self.length < 6 || [self isEnString] || [self isNumString] || [self isContainString:@" "]) {
        result = NO;
    }else{
        result = YES;
    }
    return result;
}

/**
 * 是否是合格的身份证号码
 */
- (BOOL)isValidIDNumber
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isValid = [pred evaluateWithObject:self];
    return isValid;
}

/**
 * 是否是合格的电话号码
 */
- (BOOL)isValidPhoneNumber
{
    BOOL isValid = NO;
    if (self.length == 11) {
        isValid = YES;
    }
    
    return isValid;
    
    //    NSString *pattern = @"[1][358]\\d{9}";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    //    BOOL isValid = [pred evaluateWithObject:self];
    //    return isValid;
}

+(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

@end
