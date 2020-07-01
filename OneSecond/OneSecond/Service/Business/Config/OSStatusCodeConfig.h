//
//  OSStatusCodeConfig.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
/** success */
#define SUCCESS_CODE        @"200"
/** error */
#define WARMING_CODE        @"500"
#define PARAM_ERROR_CODE    @"400"
/** warning */
#define SESSION_EXPIRE      @"1001"
#define DEVICETOKEN_EXPIRE  @"1002"
#define PASSWORD_ERROR      @"1030"
#define ACCOUNT_LOCKED      @"2009"
#define PAYMENT_PASSWORD_ERROR @"1080"
/** network error */
#define NETWORK_ERROR       @"-1009"

#define NEXTDAY_ERROR       @"-1011"

@interface OSStatusCodeConfig : NSObject

/** 默认弹框提示 */
+ (BOOL)isDefaultStatus:(NSString *)statusCode;

@end
