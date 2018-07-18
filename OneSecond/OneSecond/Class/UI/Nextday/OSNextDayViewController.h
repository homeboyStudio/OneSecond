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

- (void)updateUI;
- (void)cleanUpUI;
@end
