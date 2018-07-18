//
//  OSNextDayViewController.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/25.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSRootViewController.h"
#import "OSMusicPlayer.h"

@interface OSNextDayViewController : OSRootViewController

@property (nonatomic, strong) NSString *inputDateStr; // 所需显示的日期 (string)
@property (nonatomic, strong) NSDate *inputDate; // 所需显示的日期

@property (nonatomic, assign) NSInteger status; // 1 = 作为现在正在展示的view 0 = 缓存的view

- (void)updateUI;
- (void)cleanUpUI;

@end


