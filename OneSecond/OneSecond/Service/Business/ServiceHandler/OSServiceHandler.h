//
//  OSServiceHandler.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSRootBean.h" 
#import "OSServiceDispatch.h"
#import "OSServiceConfigManager.h" 
#import "OSServiceCallBack.h"

@interface OSServiceHandler : NSObject

@property (nonatomic, strong) OSRootBean *bean;
@property (nonatomic, copy) NSString *serviceTag;
@property (nonatomic, strong) OSAPIModel *apiModel; // API MODEL
@property (nonatomic, assign) eHttpHostType hostType;
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

/** 是否需要框架层弹出waring 警告框 默认为YES*/
@property (nonatomic, assign) BOOL ifNeedErrorAlert;
/** 是否显示loading view 默认显示*/
@property (nonatomic, assign) BOOL ifNeedLoadingView;

- (void)serviceHandlerRequest:(serviceSuccessBlock)success
                  failedBlock:(serviceFailedBlock)failed;

- (void)serviceHandlerResponse:(OSObject *)result
                  successBlock:(serviceSuccessBlock)success
                   failedBlock:(serviceFailedBlock)failed;

// 如果网络层返回失败则直接调用该方法
- (void)checkResponseStatus:(OSObject *)result
               successBlock:(serviceSuccessBlock)success
                failedBlock:(serviceFailedBlock)failed
                      error:(NSError *)error;
@end
