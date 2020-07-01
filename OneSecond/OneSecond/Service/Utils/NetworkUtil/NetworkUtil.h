//
//  NetworkUtil.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, eNetworkType) {
    eNetworkType_None,
    eNetworkType_WIFI,
    eNetworkType_Cellular
};

#define kNetworkDidChangedNotification @"kNetworkDidChangedNotification"

@interface NetworkUtil : NSObject

+ (NetworkUtil *)sharedInstance;

+ (void)releaseNetworkUtil;

@property (nonatomic, readonly) eNetworkType networkType;

@end
