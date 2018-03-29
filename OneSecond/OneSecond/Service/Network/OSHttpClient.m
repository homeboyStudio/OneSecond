//
//  OSHttpClient.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/23.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSHttpClient.h"
#import "AFHTTPSessionManager.h"

@interface OSHttpClient()

@property (nonatomic, strong) NSString *bashPath;
@property (nonatomic, strong) NSMutableDictionary *HTTPHeaderFields;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation OSHttpClient

+ (OSHttpClient *)sharedInstanceWithClientType:(eHttpHostType)type
{
    static NSMutableDictionary *__instanceMap = nil;
    static dispatch_once_t  oncePreicate;
    dispatch_once(&oncePreicate, ^{
        __instanceMap = [[NSMutableDictionary alloc] init];
    });
    // 这里如果有多个服务的话可以配置多个Client
    OSHttpClient *__sharedInstance = [__instanceMap objectForKey:@(type)];
    if (!__sharedInstance) {
        @synchronized(self) {
            if (!__sharedInstance) {
                __sharedInstance = [[self alloc] init];
                __sharedInstance.bashPath = [[OSServiceConfigManager sharedInstance] getHostByType:type];
                // 这里以后替换为其他的网络框架
                __sharedInstance.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:__sharedInstance.bashPath]];
                __sharedInstance.sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                [__instanceMap setObject:__sharedInstance forKey:@(type)];
            }
        }
    }
    return __sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.bashPath = @"";
    }
    return self;
}

#pragma mark ------------ AFNetworking 访问服务框架 ----------------------------

- (NSURLSessionDataTask *)GET:(NSString *)path
 parameters:(NSDictionary *)parameters
    success:(OSHttpSuccessBlock)success
     failed:(OSHttpFailedBlock)failed
{
    // 这里本来与拼接完整的URL的，但是使用AFNetworking所以已经初始化了
   return [self.sessionManager GET:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject, task);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(task, error);
    }];
}

@end
