//
//  WeiboShareActivity.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
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
