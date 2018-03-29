//
//  OSGuidingView.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/16.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSGuidingView.h"
#import "THLabel.h"

#define offsetHeight ([OSDevice isDeviceIPhone4s] ? -10 : ([OSDevice isDeviceIPhone5] ? 0 : ([OSDevice isDeviceIPhone6] ? 30 : 60)))
#define offsetFont ([OSDevice isDeviceIPhone4s] ? 1 : ([OSDevice isDeviceIPhone5] ? 1 : ([OSDevice isDeviceIPhone6] ? 0 : 0)))
@interface OSGuidingView()

@property (nonatomic, weak) IBOutlet THLabel *helloLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;      // 文案标题
@property (nonatomic, weak) IBOutlet UITextView *detailLabel;  // 详细文案

@end

@implementation OSGuidingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (OSGuidingView *)loadFromNib
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OSGuidingView" owner:self options:nil];
    return [nibArray objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 动画
   
//    [_helloLabel  setHidden:YES];
//    [_titleLabel setHidden:YES];
//    [_detailLabel setHidden:YES];
    [_helloLabel setFrame:CGRectMake(0, 120 + offsetHeight, DEVICE_WIDTH, 60)];
    [_helloLabel setTextColor:[OSColor pureWhiteColor]];
    [_helloLabel setFont:[OSFont nextDayFontWithSize:HighlightNumberFontSize + 30 - offsetFont]];
    _helloLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.4];
    _helloLabel.shadowOffset = CGSizeMake(0.5, 1.5);
    _helloLabel.shadowBlur = 2.0f;
    [_helloLabel setAdjustsFontSizeToFitWidth:YES];

    [_titleLabel setFrame:CGRectMake(0, CGRectGetMaxY(_helloLabel.frame) + 90 + offsetHeight, DEVICE_WIDTH, 30)];
    [_titleLabel setTextColor:[OSColor pureWhiteColor]];
    [_titleLabel setFont:[OSFont nextDayFontWithSize:HighlightFontSize - offsetFont]];
    
    [_detailLabel setFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, DEVICE_WIDTH - 30, 200)];
    // 欢迎使用一秒 OneSecond  一秒为大家提供一种全新记录生活的方式
    // 每天坚持记录只属于你的一个片段，一秒为大家提供制作记录生活的精美视频的方式。
    // 每天记录只属于你的一个片段，快乐亦或是悲伤，都值得记录，觉得每天一成不变，那就去寻找让你觉得有趣的生活。
    [_detailLabel setAttributedText:[self getAttributedTitleString:@"记录只属于你的一个片段,觉得每天一成不变,就去寻找让你觉得有趣的生活。"]];
    [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    
    // 开始动画
    [_helloLabel setAlpha:0.0f];
    [_titleLabel setAlpha:0.0f];
    [_detailLabel setAlpha:0.0f];
    [UIView animateWithDuration:.8f animations:^{
        [_helloLabel setAlpha:1.0];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5f animations:^{
            [_titleLabel setAlpha:1.0f];
            [_detailLabel setAlpha:1.0f];
        } completion:^(BOOL finished) {
            
        }];
        
    }];
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
