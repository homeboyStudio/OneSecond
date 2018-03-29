//
//  OSRootViewController.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNavigationController.h"
#import "UIViewController+OSNavigationBar.h"
#import "OSRootBean.h"

@interface OSRootViewController : UIViewController

/** 页面业务model */
@property (nonatomic, strong) OSRootBean *bean;

/** 导航控制器 */
@property (nonatomic, weak) OSNavigationController *osNavigationController;


/**
 * 返回按钮点击，特殊情况可以重载此方法
 *
 * @param sender  返回按钮对象
 */
- (void)backBarButtonItemClicked:(id)sender;


@end
