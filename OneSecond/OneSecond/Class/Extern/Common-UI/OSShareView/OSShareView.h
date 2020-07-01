//
//  OSShareView.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OSShareView : UIView <UIGestureRecognizerDelegate>

/**
 * 从底部向上弹出一个ActionSheet样式的分享列表(可以直接在文字中添加URL信息)
 * @param  需要显示分享的Controller
 * @param  需要分享的文字
 */
+ (void)showSocialSharePanelWith:(UIViewController *)viewController shareContext:(NSString *)string;

/**
 * 从底部向上弹出一个ActionSheet样式的分享列表(可以直接在文字中添加URL信息)
 * @param  需要显示分享的Controller
 * @param  需要分享的标题（可选）
 * @param  需要分享的文字（可选）
 * @param  需要分享的图片（可选）
 * @param  需要分享的URL（可选,为如下格式"http://www.pierup.cn"）
 */
+ (void)showSocialSharePanelWith:(UIViewController *)viewController shareTitle:(NSString *)title shareContext:(NSString *)string imageData:(UIImage *)image url:(NSString *)url;

@end
