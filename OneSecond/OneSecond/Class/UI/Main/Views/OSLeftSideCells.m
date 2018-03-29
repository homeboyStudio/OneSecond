//
//  OSLeftSideCells.m
//  OneSecond
//
//  Created by JHR on 15/10/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSLeftSideCells.h"

@implementation OSLeftSideCells

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

@implementation OSLeftHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end

@implementation OSOneSecondCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.itemButton setTitleColor:[OSColor specialDarkColor] forState:UIControlStateNormal];
    [self.itemButton setTitleColor:[OSColor skyBlueColor] forState:UIControlStateHighlighted];
    [self.itemButton setTitleColor:[OSColor specialGaryColor] forState:UIControlStateSelected];
    
    [self.itemButton.titleLabel setFont:[OSFont nextDayFontWithSize:TableTextFontSize]];
    
    CGFloat left = 90.0f;
    if ([OSDevice isDeviceIPhone4s]) {
        left = 70.0f;
    }else if ([OSDevice isDeviceIPhone5]) {
        left = 70.0f;
    }else if ([OSDevice isDeviceIPhone6Plus]) {
        left = 100.0f;
    }
    
    [self.itemButton setContentEdgeInsets:UIEdgeInsetsMake(0,left, 0, 0)];
}

- (IBAction)buttonItemClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClickItem:)]) {
        [self.delegate buttonClickItem:sender.tag];
    }
}

@end