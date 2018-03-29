//
//  WeiboShareActivity.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/16.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "WeiboShareActivity.h"

@implementation WeiboShareActivity

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"sinaWeibo.png"];
}

- (NSString *)activityTitle
{
    return @"新浪微博";
}

- (void)activityDidFinish:(BOOL)completed
{

}

@end
