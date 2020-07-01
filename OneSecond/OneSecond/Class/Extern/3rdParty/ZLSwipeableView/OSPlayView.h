//
//  OSPlayView.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
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
