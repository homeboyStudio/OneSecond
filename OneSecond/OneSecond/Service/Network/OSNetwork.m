//
//  OSNetwork.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSNetwork.h"

@implementation OSNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ifNeedErrorAlert = YES;
        _ifNeedLoadingView = YES;
    }
    return self;
}

- (void)serverSend:(NSString *)serverTag bean:(OSRootBean *)bean successBlock:(serviceSuccessBlock)success failedlock:(serviceFailedBlock)failed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *serviceTagAry = [serverTag componentsSeparatedByString:@"_"];
        if ([serviceTagAry count] == 2) {
            NSString *rootNode = [serviceTagAry objectAtIndex:0];
            NSString *apiNode = [serviceTagAry objectAtIndex:1];
            NSDictionary *serviceConfigMap = [[OSServiceConfigManager sharedInstance] serviceConfigModelMap];
            OSServiceConfigModel *configModel = [serviceConfigMap objectForKey:rootNode];
            OSAPIModel *apiModel = [configModel.apis objectForKey:apiNode];
        
            Class serviceHandler = NSClassFromString(configModel.handler);
            OSServiceHandler *handler = [[serviceHandler alloc] init];
            handler.ifNeedErrorAlert = _ifNeedErrorAlert;
            handler.ifNeedLoadingView = _ifNeedLoadingView;
            handler.bean = bean;
            handler.serviceTag = serverTag;
            handler.apiModel = apiModel;
            handler.hostType = configModel.hostType;
    
            [handler serviceHandlerRequest:success failedBlock:failed];
        }
    });
    
}

@end
