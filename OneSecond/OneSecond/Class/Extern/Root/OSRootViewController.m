//
//  OSRootViewController.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSRootViewController.h"
#import "OSDevice.h"
#import "OSNavigationBar.h"

@interface OSRootViewController()
{
    UIWindow *applicationWindow_;
}
@end

@implementation OSRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 指示是否导航栏是半透明的 默认是YES
    if (self.navigationController) {
        self.osNavigationController = (OSNavigationController *)self.navigationController;
        if ([self.osNavigationController.viewControllers count] > 1) {
            // 通过NavigationBar延展，自定义通用返回按钮
//            [self setBackBarButtonWithTarget:self action:@selector(backBarButtonItemClicked:)];
        }
//        else if ([self.osNavigationController.viewControllers count] == 1) {
//            id rootViewController = applicationWindow_.rootViewController;
//        }
    }
}

- (void)initBaseData
{
    applicationWindow_ = [[UIApplication sharedApplication].delegate window];
}

#pragma mark ------------- 按钮事件 ------------------
- (void)backBarButtonItemClicked:(id)sender
{
//    if ([self.osNavigationController.viewControllers count] > 1) {
//        [self.osNavigationController popViewControllerAnimated:YES];
//    }
//    else if ([self.osNavigationController.viewControllers count] == 1) {
//        [self.osNavigationController dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
}

@end
