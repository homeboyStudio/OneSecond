//
//  OSUserServiceHandler.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSUserServiceHandler.h"
#import "OSUserBean.h"

@implementation OSUserServiceHandler

// 父类实现 子类实现当前Handle层中需要处理的数据
- (void)serviceHandlerRequest:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed
{
    OSUserBean *userBean = (OSUserBean *)self.bean;
    
    if ([self.serviceTag isEqualToString:SERVICE_USER_NEXTDAY]) {
        // 更新API url   userBean.dateString @"2015/12/02"

        self.apiModel.url = [userBean.dateString stringByAppendingString:@".json"];
    }
    
    // send service
    [super serviceHandlerRequest:success failedBlock:failed];
}

- (void)serviceHandlerResponse:(OSObject *)result successBlock:(serviceSuccessBlock)success failedBlock:(serviceFailedBlock)failed
{
    OSUserBean *userBean = (OSUserBean *)self.bean;
    
    if ([self.serviceTag isEqualToString:SERVICE_USER_NEXTDAY]) {
        userBean.nextDayModel = (OSResponseModel *)result;
    }
    
    [super serviceHandlerResponse:result successBlock:success failedBlock:failed];
}

@end
