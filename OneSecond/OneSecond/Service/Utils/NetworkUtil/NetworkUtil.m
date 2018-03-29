//
//  NetworkUtil.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "NetworkUtil.h"
#import "Reachability.h"

static NetworkUtil *__networkUtil = nil;

@interface NetworkUtil()

@property (nonatomic, assign) eNetworkType innerNetworkType;
@property (nonatomic, strong) Reachability *reachability;

@end

@implementation NetworkUtil

+ (NetworkUtil *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __networkUtil= [[NetworkUtil alloc] init];
    });
    return __networkUtil;
}

+ (void)releaseNetworkUtil
{
    @synchronized(self)
    {
        __networkUtil = nil;
    }
}

#pragma mark -------------- 初始化 --------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];

        [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
    
            [self performSelectorOnMainThread:@selector(networkChangedAction) withObject:NULL waitUntilDone:YES];
            
        }];
    }
    
    // 获取当前网络类型
    self.innerNetworkType = [self getCurrentNetworkType];
    
    return self;
}

#pragma mark - --------------------功能函数--------------------

- (void)networkChangedAction
{
    eNetworkType currentNetworkType = [self getCurrentNetworkType];
    if (self.innerNetworkType != currentNetworkType) {
        self.innerNetworkType = currentNetworkType;
        [self performSelectorOnMainThread:@selector(notifyNetworkChanged) withObject:NULL waitUntilDone:YES];
    }
}

- (void)notifyNetworkChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkDidChangedNotification object:NULL];
}

- (eNetworkType)getCurrentNetworkType
{
    eNetworkType networkType = eNetworkType_None;
    
    NetworkStatus networkStatus = [self.reachability currentReachabilityStatus];
    switch (networkStatus) {
        case NotReachable:
        {
            networkType = eNetworkType_None;
            break;
        }
        case ReachableViaWiFi:
        {
            networkType = eNetworkType_WIFI;
            break;
        }
        case ReachableViaWWAN:
        {

            networkType = eNetworkType_Cellular;
            break;
        }
            
        default:
        {
            networkType = eNetworkType_Cellular;
        }
            break;
    }
    
    return networkType;
}

#pragma mark 获取当前网络类型

- (eNetworkType)networkType
{
    return self.innerNetworkType;
}

@end
