//
//  OSGuidingViewModel.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSGuidingViewModel.h"

@interface OSGuidingViewModel()

@end

@implementation OSGuidingViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -------------- 功能函数 -------------------

/**
 *  根据视频地址取得AVPlayerItem对象
 *
 *  @param videoUrl 视频地址
 *
 *  @return AVPlayerItem对象
 */
+ (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl
{
    NSURL *url = [NSURL fileURLWithPath:[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    return playItem;
}

+ (NSAttributedString *)getAttributedString:(NSString *)string lineSpacing:(CGFloat)spacing fontSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spacing;  // 字体间距
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [OSFont nextDayFontWithSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName: [OSColor pureWhiteColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

@end
