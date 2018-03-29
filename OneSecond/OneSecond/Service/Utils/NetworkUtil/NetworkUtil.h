//
//  NetworkUtil.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
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
