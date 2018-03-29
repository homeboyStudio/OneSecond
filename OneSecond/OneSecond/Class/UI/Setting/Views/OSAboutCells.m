//
//  OSAboutCells.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/10.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSAboutCells.h"
#define titleFont ([OSDevice isDeviceIPhone6Plus] ? 13 : ([OSDevice isDeviceIPhone6] ? 12 : ([OSDevice isDeviceIPhone5] ? 12 : 12)))
#define detailFont ([OSDevice isDeviceIPhone6Plus] ? 11 : ([OSDevice isDeviceIPhone6] ? 10 : ([OSDevice isDeviceIPhone5] ? 10 : 10)))
@implementation OSAboutCells

// 禁止高亮状态和选中状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

@end


@implementation OSAboutSpecialCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat fontSize = AuxiliaryFontSize;
    
    if ([OSDevice isDeviceIPhone4s]) {
        fontSize = AuxiliaryFontSize + 1;
    }else if ([OSDevice isDeviceIPhone5]) {
        fontSize = AuxiliaryFontSize + 1;
    }else if ([OSDevice isDeviceIPhone6Plus]) {
        fontSize = AuxiliaryFontSize + 2;
    }else {
        fontSize = AuxiliaryFontSize + 1;
    }
    
    [_versionLabel setFont:[OSFont nextDayFontWithSize:fontSize]];
    [_nextDayLabel setFont:[OSFont nextDayFontWithSize:fontSize]];
    [_tedLabel setFont:[OSFont nextDayFontWithSize:fontSize]];
    [_thirdPartyLabel setFont:[OSFont nextDayFontWithSize:fontSize]];
    
    [_versionLabel setTextColor:[OSColor specialGaryColor]];
    [_tedLabel setTextColor:[OSColor pureDarkColor]];
    [_nextDayLabel setTextColor:[OSColor pureDarkColor]];
    [_thirdPartyLabel setTextColor:[OSColor pureDarkColor]];
    
    
}

@end


@implementation OSAboutThirdPartyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.titlelabel setTextColor:[OSColor pureDarkColor]];
    [self.titlelabel setFont:[OSFont nextDayFontWithSize:titleFont]];
    
    // iPhone 6  8.5
    [self.detailTextView setTextColor:[OSColor specialGaryColor]];
    [self.detailTextView setFont:[OSFont nextDayFontWithSize:detailFont]];
}

@end