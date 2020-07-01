//
//  OSRecordingViewController.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSRootViewController.h"
#import "OSReplayViewController.h"
//#import "OSLeftSideViewController.h"

@interface OSRecordingViewController : OSRootViewController

@property (nonatomic, weak) id<OSReplayViewControllerDelegate> delegate;

@end
