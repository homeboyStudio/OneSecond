//
//  OSReplayViewController.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSRootViewController.h"
#import "DBDateUtils.h"
#import "OSCalendarViewController.h"

@protocol OSReplayViewControllerDelegate <NSObject>

@optional
- (void)changeToCalendarViewController:(OSCalendarViewController *)vc;

@end

@interface OSReplayViewController : OSRootViewController

@property (nonatomic, strong) OSDateModel *dateModel;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) id<OSReplayViewControllerDelegate> delegate;

@end
