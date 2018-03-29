//
//  OSSettingViewCells.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/10.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSSettingViewCells.h"

#define titleFont ([OSDevice isDeviceIPhone4s] ? 15 : ([OSDevice isDeviceIPhone5] ? 16 : ([OSDevice isDeviceIPhone6] ? 16 : 17)))

@implementation OSSettingViewCells

// 禁止高亮状态和选中状态
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:NO animated:animated];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

- (void)updateCellWithIndex:(NSIndexPath *)indexPath
{

}

@end


@implementation OSSettingClearCacheCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.itemLabel setTextColor:[OSColor pureDarkColor]];
    [self.itemLabel setFont:[OSFont nextDayFontWithSize:titleFont]];
}

@end

@implementation OSSettingSetTimeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.titleLabel setTextColor:[OSColor pureDarkColor]];
    [self.titleLabel setFont:[OSFont nextDayFontWithSize:titleFont]];
    
    [self.timeLabel setTextColor:[OSColor specialDarkColor]];
    [self.timeLabel setFont:[OSFont nextDayFontWithSize:titleFont]];
}

@end

@implementation OSSettingFAQCell

@end


@implementation OSSettingFeedbackCell

@end


@implementation OSSettingRateCell

@end


@implementation OSSettingAboutCell

@end


@implementation OSSettingShareCell

@end