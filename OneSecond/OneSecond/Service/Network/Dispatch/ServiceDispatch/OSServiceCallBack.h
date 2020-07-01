//
//  OSServiceCallBack.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#ifndef OSServiceCallBack_h
#define OSServiceCallBack_h

/** 成功回调 **/
typedef void (^serviceSuccessBlock) (NSURLSessionDataTask *task);

/** 失败回调 **/
typedef void (^serviceFailedBlock) (NSURLSessionDataTask *task, NSError *error);

#endif
