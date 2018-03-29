//
//  OSServiceHandler.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSServiceHandler.h"
#import "OSStatusCodeConfig.h"
#import "NSString+Check.h"

@implementation OSServiceHandler

- (void)setRequestHeader
{
    // 绑定一些参数例如sessionToken，device token.
}

// 请求
- (void)serviceHandlerRequest:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed
{
    [self setRequestHeader];
    
    // 这里根据hostType来判断初始化或者去处某一个HttpClient类的实例对象
   _sessionDataTask = [[OSServiceDispatch sharedInstance:self.hostType] serviceStart:success failedBlock:failed handler:self];
    // 要将task添加到全局队列，取消服务使用。
    // 这里本应该获取NSOperation对象用于取消线程所用
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        if (self.ifNeedLoadingView) {
            
        }
    });
}

// 成功返回调用
- (void)serviceHandlerResponse:(OSObject *)result successBlock:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed
{
    [self checkResponseStatus:result successBlock:success failedBlock:failed error:nil];
}


// 如果网络层返回失败则直接调用该方法
- (void)checkResponseStatus:(OSObject *)result
               successBlock:(serviceSuccessBlock)success
                failedBlock:(serviceFailedBlock)failed
                      error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (self.ifNeedLoadingView) {
        
        }
    });
    
    if (result) {
        if (error == nil) {
            error = [NSError errorWithDomain:result.message code:[result.code integerValue] userInfo:nil];
        }
        
        /** 如果 status_code在名单内则弹框 */
        if ([OSStatusCodeConfig isDefaultStatus:result.code] ||
            [result.code isEqualToString:SUCCESS_CODE] ||
            [NSString emptyOrNull:result.code]) {
            // 移除线程
            
            
            /**---------------------------- 异常警告处理 ----------------------------*/
            if ([result.code isEqualToString:SESSION_EXPIRE]) {
                // session 过期
            }else if ([result.code isEqualToString:PASSWORD_ERROR]) {
                // 密码错误
            }else if ([result.code isEqualToString:DEVICETOKEN_EXPIRE]) {
                // 设备指纹校验失败
            }else if ([result.code isEqualToString:NEXTDAY_ERROR]) {
                failed(_sessionDataTask, error);
                return;
            }
            
            /**---------------------------------------------------------------------*/
            __dataSource.session_token = result.session_token;
            success(_sessionDataTask);

        }else {
        /** 网络连接失败提示信息 */
            if ([result.code isEqualToString:NETWORK_ERROR]) {
            // 网络不可用
            }else {
                if (self.ifNeedErrorAlert) {
                //  其他服务发送失败，弹框警告
                }else {
                    //不需要弹出登陆框，由业务层 failed block中自己处理.
                }
                failed(_sessionDataTask, error);
            }
        }
    }else {
//        [PIRCustomAlertView showAlertWithMessage:PIRLocalizedString(@"SERVER_ERROR")];
        failed(_sessionDataTask,nil);
    }
}

@end
