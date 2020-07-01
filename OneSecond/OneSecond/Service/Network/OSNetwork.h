//
//  OSNetwork.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSServiceHandler.h"


@interface OSNetwork : NSObject

/** 是否需要框架层弹出waring 警告框 默认为YES*/
@property (nonatomic, assign) BOOL ifNeedErrorAlert;

/** 是否显示loading view 默认显示*/
@property (nonatomic, assign) BOOL ifNeedLoadingView;

/**
 * 调用服务统一入口
 * @param NSString 对应PIRServiceConfig.plist配置表的root节点
 * @param PIRRootBean 当前页面的bean
 * @param servsBiceSuccessBlock 成功回调
 * @param serviceFailedBlock 失败回调
 */
- (void)serverSend:(NSString *)serverTag
              bean:(OSRootBean *)bean
              successBlock:(serviceSuccessBlock)success
              failedlock:(serviceFailedBlock)failed;

@end
