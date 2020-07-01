//
//  OSDataSource.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
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
