//
//  OSServiceDispatch.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSServiceDispatch.h"
#import "OSResponseModel.h"
#import "NSString+Check.h"
#import "OSUserBean.h"
#import "OSUserModel.h"
#import "OSStatusCodeConfig.h"

static OSServiceDispatch *__sharedInsance;

@interface OSServiceDispatch()

@property (nonatomic, strong)  OSHttpClient *osHttpClient;

@end

@implementation OSServiceDispatch

+ (OSServiceDispatch *)sharedInstance:(eHttpHostType)hostType
{
    if (!__sharedInsance) {
        @synchronized(self) {
            if (!__sharedInsance) {
                __sharedInsance = [[OSServiceDispatch alloc] init];
            }
        }
    }
    __sharedInsance.osHttpClient = [__sharedInsance getHttpClient:hostType];
    return __sharedInsance;
}

- (OSHttpClient *)getHttpClient:(eHttpHostType)hostType
{
    return [OSHttpClient sharedInstanceWithClientType:hostType];
}

- (NSURLSessionDataTask *)serviceStart:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed handler:(OSServiceHandler *)hanlder
{
    OSAPIModel *apiModel = hanlder.apiModel;
    DLog(@"[Request]\n:%@",[hanlder.bean getProperty]);
    
    if (apiModel.method == eHttpMethodType_get) {   // GET
      return [self startRequestGET:success failedBlock:failed handler:hanlder];
    }else if (apiModel.method == eHttpMethodType_post) {
    
    }else if (apiModel.method == eHttpMethodType_postFile) {
    
    }else if (apiModel.method == eHttpMethodType_json) {
    
    }else if (apiModel.method == eHttpMethodType_put) {
    
    }else {
    
    }
    return nil;
}

#pragma mark ----------- HTTP METHOD ------------

- (NSURLSessionDataTask *)startRequestGET:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed handler:(OSServiceHandler *)hanlder
{
  return [__sharedInsance.osHttpClient GET:hanlder.apiModel.url parameters:[hanlder.bean getProperty] success:^(id response, NSURLSessionDataTask *task) {
        [self executeSuccess:task responseObject:response success:success failed:failed handler:hanlder];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [self executeFailed:task NSError:error success:success failed:failed handler:hanlder];
    }];
}

#pragma makr ------- 功能函数 -----------------------

- (void)executeSuccess:(NSURLSessionDataTask *)task
        responseObject:(id)responseObject
               success:(serviceSuccessBlock)success
                failed:(serviceFailedBlock)failed
               handler:(OSServiceHandler *)handler
{
    DLog(@"responseObject:%@",responseObject);
    // 返回给handler层处理数据
    // 根据handler里的返回数据类型，反序列化或者直接返回字典
    if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSMutableDictionary class]]) {
        Class outPutType = NSClassFromString([handler.apiModel output]);
        NSDictionary *responseDic = nil;
        if ([[responseObject allKeys] firstObject]) {
            responseDic = [responseObject objectForKey:[[responseObject allKeys] firstObject]];
        }else {
            responseDic = responseObject;
        }
        
        // 反序列化或者返回字典
        if ([NSStringFromClass(outPutType) isEqualToString:@"OSResponseModel"]) {
             /** 直接返回dictionary */
            OSResponseModel *resultModel = [[OSResponseModel alloc] init];
            
            // 这里需要特别注意，目前访问的API并没有下发这两个字段，所以这里使用Hard coding
            
//            NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
//            if (![NSString emptyOrNull:code] && ![code isEqualToString:@"(null)"]) {
//                resultModel.code = code;
//            }else{
                resultModel.code = SUCCESS_CODE;
//            }
            
//            NSString *message = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
//            if ([NSString emptyOrNull:message] && [code isEqualToString:@"(null)"]) {
                resultModel.message = @"数据返回成功";
//            }
            
            resultModel.resultJsonModel = responseObject;
            [handler serviceHandlerResponse:resultModel successBlock:success failedBlock:failed];
            
        }else {
            // 序列化
            OSObject *resultModel = [OSResponseModel getObjectByDictionary:responseDic clazz:outPutType];
            NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
            
            // 同上需求
            if (![NSString emptyOrNull:code]) {
                resultModel.code = code;
            }else{
                resultModel.code = @"200";
            }
            [handler serviceHandlerResponse:resultModel successBlock:success failedBlock:failed];
        }
    } else {
        DLog(@"ERROR:%@",@"Response data error.");
    }
}

- (void)executeFailed:(NSURLSessionDataTask *)task
              NSError:(NSError *)error
              success:(serviceSuccessBlock)success
               failed:(serviceFailedBlock)failed
              handler:(OSServiceHandler *)handler
{
    //status_code != 200
    DLog(@"urlResponse:%@",task);
    if (error != nil) {
        NSError *nserror = (NSError *)error;
        OSObject *mockResponse = [[OSObject alloc] init];
        mockResponse.code = [NSString stringWithFormat:@"%ld",(long)nserror.code];
        mockResponse.message = nserror.domain;
        [handler checkResponseStatus:mockResponse successBlock:success failedBlock:failed error:nserror];
    }else {
        failed(task, error);
        if (handler.ifNeedErrorAlert) {
            // 框架层弹框
            // 网路不给力，超时了！
        }
    }
    
}

#pragma mark ------- 清空 -------------

+ (void)releaseInstance
{
    __sharedInsance = nil;
}

@end
