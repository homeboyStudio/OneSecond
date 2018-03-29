//
//  OSRecordingViewController.h
//  OneSecond
//
//  Created by JunhuaRao on 15/10/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSRootViewController.h"
#import "OSReplayViewController.h"
//#import "OSLeftSideViewController.h"

@interface OSRecordingViewController : OSRootViewController

@property (nonatomic, weak) id<OSReplayViewControllerDelegate> delegate;

@end
