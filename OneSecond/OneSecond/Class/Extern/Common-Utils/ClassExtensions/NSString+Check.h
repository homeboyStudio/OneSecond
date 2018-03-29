//
//  NSString+Check.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

typedef NS_ENUM(NSInteger, eDOBFormate){
    eDOBFormate_invalid,
    eDOBFormate_available,
    eDOBFormate_less18,
    eDOBFormate_more120
};

/**
 * 判断字串是否是空
 */
+ (BOOL)emptyOrNull:(NSString *)str;

/**
 * 获取非nil的string
 */
+ (NSString *)getUnNilString:(NSString *)str;

/**
 *  数组判断工具
 *
 *  @param array 数组
 *
 *  @return 是否为空
 */
+ (BOOL)arrayEmptyOrNull:(NSArray *)array;

/**
 * 判断字串是否是数字
 */
- (bool)isNumString;

/**
 * 是否是英文
 */
- (bool)isEnString;

/**
 * 是否只有英文或者数字
 */
- (BOOL)isStringOnlyEnOrNum;

/**
 * 是否是中文
 */
- (bool)isValidCN;

/**
 * email是否合法
 */
- (bool)isValidEmail;

/**
 * dob法
 */

- (eDOBFormate)checkDOBFormate;

/**
 * 计算字串的长度(按字节计算，一个中文返回2)
 */
- (int)strByteLength;

/**
 * 是否包含子串
 */
- (BOOL)isContainString:(NSString *)subString;

/**
 * 身份证号码格式化
 */
- (NSString *)idNumberFormat;

/**
 * 电话号码格式化
 * 10位：(000)000-0000
 * 11位：000-0000-0000
 */
- (NSString *)phoneFormat;

- (NSString *)phoneClearFormat;

/**
 * 生日格式化
 */
- (NSString *)dobFormat;

/**
 * 是否是合格的SSN
 */
- (BOOL)isValidSSN;

/**
 * 获取字符串中的数字
 */
+ (NSString *)getNumbers:(NSString*)stirng;


/**
 * 金额字符串
 * USD：@"$"  //en_US
 * RMB：@"￥" //zh_CN
 */
+ (NSString *)getAmountFormatterDecimalStyle:(NSString *)number currency:(NSString *)currency;

/**
 * 是否是合格的密码
 */
- (BOOL)isValidPassword;

/**
 * 是否是合格的身份证号码
 */
- (BOOL)isValidIDNumber;

/**
 * 现仅校验11位长度，不做以下正规约束
 *
 * 移动：134、135、136、137、138、139、150、151、157(TD)、158、159、187、188
 * 联通：130、131、132、152、155、156、185、186
 * 电信：133、153、180、189、（1349卫通）
 */
- (BOOL)isValidPhoneNumber;

/**
 * DECODE URL
 */
+ (NSString *)URLDecodedString:(NSString *)str;

@end
