//
//  OSNavigationController.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSNavigationController.h"

@interface OSNavigationController ()

@end

@implementation OSNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 统一返回按钮样式
    UIImage *backButtonImage = [[UIImage imageNamed:@"btn_back_arrow_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setBarTintColor:[OSColor skyBlueColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 让View高度包括导航栏高度
    self.navigationBar.translucent = YES;
//    self.navigationBarBackgroundAlpha = 0.0f;
}

#pragma mark --------- 退出清空 -------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
