//
//  OSServiceConfigManager.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSServiceConfigManager.h"

#define SERVICE_CONFILE_NAME_LOCAL    @"OSServiceConfig"

#define SERVICE_HANLDER         @"handler"
#define SERVICE_BEAN            @"bean"
#define SERVICE_API             @"api"
#define SERVER_HOSTTYPE         @"hostType"
#define SERVER_HOST             @"host"

#define SERVICE_API_URL         @"url"
#define SERVICE_API_METHOD      @"method"
#define SERVICE_API_INPUT       @"input"
#define SERVICE_API_OUTPUT      @"output"

#define HTTP_METHOD_GET         @"get"
#define HTTP_METHOD_POST        @"post"
#define HTTP_METHOD_POST_File   @"postFile"
#define HTTP_METHOD_POST_JOSN   @"postJson"
#define HTTP_METHOD_PUT         @"put"

@implementation OSServiceConfigModel
@end

@implementation OSAPIModel
@end

static OSServiceConfigManager *__sharedInstance;

@implementation OSServiceConfigManager

+ (instancetype)sharedInstance
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __sharedInstance = [[OSServiceConfigManager alloc] init];
            
            // plist --> Dic
            [__sharedInstance obtainServiceInfoMap:SERVICE_CONFILE_NAME_LOCAL];
        });
    
    return __sharedInstance;
}

/**
 * 获取所有serverConfig配置文件信息类信息
 */
- (void)obtainServiceInfoMap:(NSString *)configFile
{
    if (!_serviceConfigModelMap) {
        _serviceConfigModelMap = [[NSMutableDictionary alloc] init];
        
         NSMutableDictionary *serviceRootMap = [[NSMutableDictionary alloc] init];
    //调试环境使用铭文配置表
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:configFile ofType:@"plist"];
    // plist ---> Dic
    NSDictionary *sourcesMap = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    // 遍历
    
    for (NSString *key in sourcesMap) {
        // 目前只有一个key user
        NSDictionary *serviceMap = [sourcesMap objectForKey:key];
        OSServiceConfigModel *serviceModel = [[OSServiceConfigModel alloc] init];
        serviceModel.handler = [serviceMap objectForKey:SERVICE_HANLDER];
        serviceModel.bean = [serviceMap objectForKey:SERVICE_BEAN];
        serviceModel.hostType = [[serviceMap valueForKey:SERVER_HOSTTYPE] intValue];
        serviceModel.host = [serviceMap valueForKey:SERVER_HOST];
        
        /** API */
        NSMutableDictionary *tempAPIMap = [[NSMutableDictionary alloc] init];
        NSDictionary *apis = [serviceMap objectForKey:SERVICE_API];   // 该服务下所有的APIs
        for (NSString *subKey in [apis allKeys]) {
            OSAPIModel *apiModel = [[OSAPIModel alloc] init];
            // 反序列化
            NSDictionary *tempMap = [apis objectForKey:subKey];
            apiModel.url = [[tempMap objectForKey:SERVICE_API_URL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *method = [[tempMap objectForKey:SERVICE_API_METHOD]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([method isEqualToString:HTTP_METHOD_GET]) {
                apiModel.method = eHttpMethodType_get;
            }else if ([method isEqual:HTTP_METHOD_POST]){
                apiModel.method = eHttpMethodType_post;
            }else if ([method isEqual:HTTP_METHOD_POST_File]){
                apiModel.method = eHttpMethodType_postFile;
            }else if ([method isEqualToString:HTTP_METHOD_POST_JOSN]){
                apiModel.method = eHttpMethodType_json;
            }else if ([method isEqualToString:HTTP_METHOD_PUT]){
                apiModel.method = eHttpMethodType_put;
            }
            apiModel.input = [[tempMap objectForKey:SERVICE_API_INPUT] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            apiModel.output = [[tempMap objectForKey:SERVICE_API_OUTPUT] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [tempAPIMap setValue:apiModel forKey:subKey];
        }
        serviceModel.apis = tempAPIMap;
        [serviceRootMap setValue:serviceModel forKey:key];
    }
        // DIC --> user : OSServiceConfigModel 
        _serviceConfigModelMap = serviceRootMap;
  }
}

- (NSString *)getHostByType:(eHttpHostType)hostType
{
     NSString *host = @"";
    for (NSString *key in [_serviceConfigModelMap allKeys]) {
        OSServiceConfigModel *model = [_serviceConfigModelMap objectForKey:key];
        if (model.hostType == (NSInteger)hostType) {   // 0,1
            host = model.host;
        }
    }
    return host;
}

@end
