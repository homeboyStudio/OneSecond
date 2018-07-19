//
//  OSGuidingFourthView.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSGuidingFourthView.h"
#import "UIImage+OSColor.h"
#import "OSDevice.h"

#define buttonheight ([OSDevice isDeviceIPhone4s] ? 40 : ([OSDevice isDeviceIPhone5] ? 40 : ([OSDevice isDeviceIPhone6] ? 50 : 50)))

#define offsetFont ([OSDevice isDeviceIPhone4s] ? 1 : ([OSDevice isDeviceIPhone5] ? 1 : ([OSDevice isDeviceIPhone6] ? 0 : 0)))
#define offsetHeight ([OSDevice isDeviceIPhone4s] ? -10 : ([OSDevice isDeviceIPhone5] ? 10 : ([OSDevice isDeviceIPhone6] ? 30 : 60)))

@interface OSGuidingFourthView()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UITextView *detailTextView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, assign) BOOL isShowed;

@end

@implementation OSGuidingFourthView

+ (instancetype)loadFromNib
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OSGuidingFourthView" owner:self options:nil];
    return [nibArray objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_logoImageView setFrame:CGRectMake((DEVICE_WIDTH - 80)/2, 120 + offsetHeight, 80, 80)];

    [_detailTextView setFrame:CGRectMake(15, 180 + 90 + 2*offsetHeight + 40, DEVICE_WIDTH - 30, 150)];
    [_detailTextView setAttributedText:[self getAttributedTitleString:@"开始使用一秒"]];
    [_detailTextView setTextAlignment:NSTextAlignmentCenter];
    
    [_startButton setFrame:CGRectMake(40, DEVICE_HEIGHT - 3 * buttonheight, DEVICE_WIDTH - 80, buttonheight)];
    [_startButton.layer setCornerRadius:4.f];
    [_startButton.layer setMasksToBounds:YES];
//    [_startButton setBackgroundImage:[UIImage imageFromColor:[OSColor colorFromHex:@"49C6D8" alpha:0.7]] forState:UIControlStateNormal];
    [_startButton setBackgroundColor:[OSColor colorFromHex:@"49C6D8" alpha:.8]];

    //  49C6D8
    [_startButton.titleLabel setFont:[OSFont nextDayFontWithSize:ExplanatoryFontSize]];
    [_startButton setTitleColor:[OSColor colorFromHex:@"FFFFFF" alpha:.8] forState:UIControlStateNormal];
   
    
    [_logoImageView setAlpha:0];
    [_detailTextView setAlpha:0];
    [_startButton setAlpha:0];
}

- (NSAttributedString *)getAttributedTitleString:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f - offsetFont;  // 字体间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName:[OSFont nextDayFontWithSize:HighlightFontSize - offsetFont],NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName : [OSColor pureWhiteColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

- (IBAction)startButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoMainViewController)]) {
        [self.delegate gotoMainViewController];
    }
}

#pragma mark ------------------ 接口API ----------------------
- (void)startAnimation
{
    if (!self.isShowed) {
        [UIView animateWithDuration:.5f animations:^{
            [self.logoImageView setAlpha:.8f];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.5f animations:^{
                [self.detailTextView setAlpha:1.0f];
                [self.startButton setAlpha:1.0f];
            } completion:^(BOOL finished) {
                self.isShowed = YES;
            }];
        }];
    }
}

@end
