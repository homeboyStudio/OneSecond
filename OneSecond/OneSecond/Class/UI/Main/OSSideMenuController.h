//
//  OSSideMenuController.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "LGSideMenuController.h"
#import "OSLeftSideViewController.h"
#import "OSVideoPlayerViewController.h"

@interface OSSideMenuController : LGSideMenuController

@property (nonatomic, strong) OSLeftSideViewController *leftSideViewController;
@property (nonatomic, strong) OSVideoPlayerViewController *videoPlayerViewController;

@end
