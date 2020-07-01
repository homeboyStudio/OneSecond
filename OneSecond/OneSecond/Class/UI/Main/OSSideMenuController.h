//
//  OSSideMenuController.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "LGSideMenuController.h"
#import "OSLeftSideViewController.h"
#import "OSVideoPlayerViewController.h"

@interface OSSideMenuController : LGSideMenuController

@property (nonatomic, strong) OSLeftSideViewController *leftSideViewController;
@property (nonatomic, strong) OSVideoPlayerViewController *videoPlayerViewController;

@end
