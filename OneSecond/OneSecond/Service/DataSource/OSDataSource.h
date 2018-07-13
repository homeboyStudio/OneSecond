//
//  OSDataSource.h
//  OneSecond
//
//  Created by JHR on 15/10/18.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkUtil.h"

@class  OSDataSource;
extern  OSDataSource *__dataSource;

void initDataSource(void);
void freeDataSource(void);

@interface OSDataSource : NSObject

@property (nonatomic, copy) NSString *session_token;

// UI 状态
@property (nonatomic, assign) eNetworkType networkType;
@property (nonatomic, assign) BOOL isNetworkAvailable;

@end
