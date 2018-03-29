//
//  OSDataSource.m
//  OneSecond
//
//  Created by JHR on 15/10/18.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSDataSource.h"

OSDataSource *__dataSource;

void initDataSource()
{
    if (__dataSource == nil) {
        __dataSource = [[OSDataSource alloc] init];
    }
}

void freeDataSource()
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
