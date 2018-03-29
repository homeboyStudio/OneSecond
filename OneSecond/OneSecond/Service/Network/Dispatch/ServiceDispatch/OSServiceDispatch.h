//
//  OSServiceDispatch.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSServiceTags.h"
#import "OSServiceConfigManager.h"
#import "OSServiceCallBack.h"
#import "OSHttpClient.h"
#import "OSServiceHandler.h"
@class OSServiceHandler;

@interface OSServiceDispatch : NSObject

+ (OSServiceDispatch *)sharedInstance:(eHttpHostType)hostType;
+ (void)releaseInstance;


/**
 * 调用服务统一接口
 * @param serviceSuccessBlock 成功回调
 * @param serviceFailedBlock 失败回调
 * @param PIRServiceHandler network时候new 的handler传过来，处理response时候继续用
 **/
- (NSURLSessionDataTask *)serviceStart:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed handler:(OSServiceHandler *)hanlder;

@end
