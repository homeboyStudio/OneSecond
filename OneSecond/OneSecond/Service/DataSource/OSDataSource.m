//
//  OSDataSource.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSDataSource.h"

OSDataSource *__dataSource;

void initDataSource(void)
{
    if (__dataSource == nil) {
        __dataSource = [[OSDataSource alloc] init];
    }
}

void freeDataSource(void)
{
    __dataSource = nil;
}

@implementation OSDataSource

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _session_token = @"";
        
        _networkType = eNetworkType_None;
        _isNetworkAvailable = NO;
    }
    
    return self;
}

@end
