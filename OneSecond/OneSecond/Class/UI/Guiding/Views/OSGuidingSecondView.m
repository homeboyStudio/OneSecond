//
//  OSGuidingSecondView.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSGuidingSecondView.h"

#define offsetHeight ([OSDevice isDeviceIPhone4s] ? -10 : ([OSDevice isDeviceIPhone5] ? 0 : ([OSDevice isDeviceIPhone6] ? 30 : 60)))
#define offsetFont ([OSDevice isDeviceIPhone4s] ? 1 : ([OSDevice isDeviceIPhone5] ? 1 : ([OSDevice isDeviceIPhone6] ? 0 : 0)))

@interface OSGuidingSecondView()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *detailTextView;
@property (nonatomic, assign) BOOL isShowed;

@end

@implementation OSGuidingSecondView

+ (instancetype)loadFromNib
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OSGuidingSecondView" owner:self options:nil];
    return [nibArray objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_titleLabel setFrame:CGRectMake(0, 180 + 90 + 2*offsetHeight, DEVICE_WIDTH, 30)];
    [_titleLabel setTextColor:[OSColor pureWhiteColor]];
    [_titleLabel setFont:[OSFont nextDayFontWithSize:HighlightFontSize - offsetFont]];
    
    [_detailTextView setFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, DEVICE_WIDTH - 30, 200)];
    // 欢迎使用一秒 OneSecond  一秒为大家提供一种全新记录生活的方式
    // 每天坚持记录只属于你的一个片段，一秒为大家提供制作记录生活的精美视频的方式。
    [_detailTextView setAttributedText:[self getAttributedTitleString:@"让你一览每月的精彩瞬间,并且可以将所有片段拼接成一部属于你们的精彩故事。"]];
    [_detailTextView setTextAlignment:NSTextAlignmentCenter];
    
    self.isShowed = NO;
    [_titleLabel setAlpha:0.0f];
    [_detailTextView setAlpha:0.0f];
}

#pragma mark ------------------ 接口API ----------------------
- (void)startAnimation
{
    if (!self.isShowed) {
        [UIView animateWithDuration:.5f animations:^{
            [_titleLabel setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.5f animations:^{
                [_detailTextView setAlpha:1.0];
            } completion:^(BOOL finished) {
                self.isShowed = YES;
            }];
        }];
    }
}

#pragma mark ------------------ 功能函数 ----------------------
- (NSAttributedString *)getAttributedTitleString:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f - offsetFont;  // 字体间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName:[OSFont nextDayFontWithSize:ExplanatoryFontSize - offsetFont],NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName : [OSColor pureWhiteColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}


@end
