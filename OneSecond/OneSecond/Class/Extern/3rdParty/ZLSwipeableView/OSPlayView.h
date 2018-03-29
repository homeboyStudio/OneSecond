//
//  OSPlayView.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/9.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@class OSDateModel;
@class OSCalendarModel;

// FXBlurView
@interface OSPlayView : FXBlurView

+ (OSPlayView *)showPlayViewWithOSCalendarModel:(OSCalendarModel *)calendarModel;

- (void)showAnimation;

@end
