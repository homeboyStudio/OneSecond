//
//  OSFaqCells.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/11.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSFaqCells.h"

#define titleFont ([OSDevice isDeviceIPhone6Plus] ? 17 : ([OSDevice isDeviceIPhone6] ? 16 : ([OSDevice isDeviceIPhone5] ? 16 : 16)))
#define detailFont ([OSDevice isDeviceIPhone6Plus] ? 15 : ([OSDevice isDeviceIPhone6] ? 14 : ([OSDevice isDeviceIPhone5] ? 14 : 14)))
@implementation OSFaqCells

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


@implementation OSFaqItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.questionTitleLabel setTextColor:[OSColor pureDarkColor]];
    [self.questionTitleLabel setFont:[OSFont nextDayFontWithSize:TableTextFontSize]];
    
    [self.questionDetailTextView setTextColor:[OSColor specialGaryColor]];
    [self.questionDetailTextView setFont:[OSFont nextDayFontWithSize:TableTitleFontSize]];
}

- (void)setAttributeString:(NSString *)title detail:(NSString *)detail
{
    [self.questionTitleLabel  setAttributedText:[self getAttributedTitleString:title]];
    [self.questionDetailTextView setAttributedText:[self getAttributedDetailString:detail]];
}

#pragma mark - --------------------功能函数--------------------
#pragma mark 初始化

- (NSAttributedString *)getAttributedTitleString:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;  // 字体间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName:[OSFont nextDayFontWithSize:titleFont],NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName : [OSColor pureDarkColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

- (NSAttributedString *)getAttributedDetailString:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;  // 字体间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName:[OSFont nextDayFontWithSize:detailFont],NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName : [OSColor specialGaryColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}
@end