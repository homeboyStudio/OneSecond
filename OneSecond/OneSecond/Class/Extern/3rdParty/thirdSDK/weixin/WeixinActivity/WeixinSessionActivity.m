//
//  WeixinSessionActivity.m
//  WeixinActivity
//
//  Created by Johnny iDay on 13-12-2.
//  Copyright (c) 2013年 Johnny iDay. All rights reserved.
//

#import "WeixinSessionActivity.h"

@implementation WeixinSessionActivity

- (UIImage *)activityImage
{
    return [[[UIDevice currentDevice] systemVersion] intValue] >= 8 ? [UIImage imageNamed:@"icon_session-8.png"] : [UIImage imageNamed:@"icon_session.png"];
    
    // return [UIImage imageNamed:@"icon_session_bg.png"];
}

- (NSString *)activityTitle
{
//    return NSLocalizedString(@"WeChat Session", nil);
    return @"微信好友";
}

- (void)activityDidFinish:(BOOL)completed
{

}

@end
