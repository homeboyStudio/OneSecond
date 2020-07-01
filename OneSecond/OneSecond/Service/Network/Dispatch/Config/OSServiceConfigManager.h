//
//  OSServiceConfigManager.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

// HTTP METHOD
typedef enum {
    eHttpMethodType_get,
    eHttpMethodType_post,
    eHttpMethodType_postFile,
    eHttpMethodType_json,
    eHttpMethodType_put
}eHttpMethodType;

// HTTP HOST TYPE
typedef enum {
    eHttpHost_common        = 0,
    eHttpHost_user          = 1
}eHttpHostType;

//  每一个服务的配置模型
@interface OSServiceConfigModel : NSObject

@property (nonatomic, copy) NSString *handler;
@property (nonatomic, copy) NSString *bean;
@property (nonatomic, strong) NSDictionary *apis; //key:tag value:[PIRAPIModel class]
@property (nonatomic, assign) int hostType; // eHttpHostType
@property (nonatomic, copy) NSString *host;  // 主机地址

@end

// API模型
@interface OSAPIModel : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) eHttpMethodType method;
@property (nonatomic, copy) NSString *input;
@property (nonatomic, copy) NSString *output;  // 返回类型

@end

@interface OSServiceConfigManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *serviceConfigModelMap; //key:user value:[PIRServiceConfigModel]

+ (instancetype)sharedInstance;

- (NSString *)getHostByType:(eHttpHostType)hostType;

@end
