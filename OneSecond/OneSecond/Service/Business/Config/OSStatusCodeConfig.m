//
//  OSStatusCodeConfig.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import "OSStatusCodeConfig.h"

static NSMutableDictionary *statusDic = nil;

@implementation OSStatusCodeConfig

+ (void)buildDic
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (statusDic == nil) {
            statusDic = [[NSMutableDictionary alloc] init];
            [statusDic setValue:SESSION_EXPIRE forKey:SESSION_EXPIRE];
            [statusDic setValue:DEVICETOKEN_EXPIRE forKey:DEVICETOKEN_EXPIRE];
            [statusDic setValue:PASSWORD_ERROR forKey:PASSWORD_ERROR];
        }
    });
}

/** 默认弹框提示 */
+ (BOOL)isDefaultStatus:(NSString *)statusCode
{
     [OSStatusCodeConfig buildDic];
    BOOL result = YES;
    if ([[statusDic valueForKey:statusCode] isEqualToString:statusCode]) {
        result = NO;
    }
    return result;
}

@end
