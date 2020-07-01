//
//  OSShareView.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSShareView.h"
#import "UIImage+OSColor.h"
#import "WXApi.h"
#import "WeiboSDK.h"

#define offsetLayoutHeight ([OSDevice isDeviceIPhone4s] ? 40 : ([OSDevice isDeviceIPhone5] ? 40 : ([OSDevice isDeviceIPhone6] ? 50 : 50)))

@interface OSSocialLabel : UILabel

@end

@implementation OSSocialLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configView];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self configView];
}

- (void)configView
{
    [self setTextColor:[OSColor specialGaryColor]];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
}

@end


typedef  NS_ENUM(NSInteger, eSocialButtonType)
{
    eWechatButtonType = 1000,
    eWechatFriendButtonType = 2000,
    eWeiboButtonType = 3000,
};

@interface OSShareView()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation OSShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    if (self) {
        [self commonInitWithFrame:frame];
    }
    return self;

}

- (void)setupUI
{

}

- (void)commonInitWithFrame:(CGRect)frame
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    // 添加手势监听
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonAction:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];

    // 添加背景
    self.backgroundView = [[UIView alloc] initWithFrame:frame];
    [_backgroundView.layer setCornerRadius:5.0f];
    [_backgroundView.layer setMasksToBounds:YES];
    [_backgroundView setBackgroundColor:[OSColor pureWhiteColor]];
   
    // 添加title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"分享一秒"];
    [label setFont:[OSFont nextDayFontWithSize:ExplanatoryFontSize]];
    [label setTextColor:[OSColor pureDarkColor]];
    [_backgroundView addSubview:label];
    
    
    // 添加Button
    [self initButtonWithImage:@"btn_contacts_wechat.png" label:@"微信好友" tag:eWechatButtonType index:0 totalLength:frame.size.width];
    [self initButtonWithImage:@"btn_contacts_friends.png" label:@"微信朋友圈" tag:eWechatFriendButtonType index:1 totalLength:frame.size.width];
    [self initButtonWithImage:@"btn_contacts_weibo.png" label:@"新浪微博" tag:eWeiboButtonType index:2 totalLength:frame.size.width];
    
    // 添加按钮到backgroundView
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.layer setCornerRadius:5.0f];
    [cancelButton setFrame:CGRectMake(15, frame.size.height - offsetLayoutHeight - 10, frame.size.width - 30, offsetLayoutHeight)];
    [cancelButton setBackgroundImage:[UIImage imageFromColor:[OSColor skyBlueColor]] forState:UIControlStateNormal];
    [cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[OSFont nextDayFontWithSize:ButtonNavFontSize]];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:cancelButton];
    
    [self insertSubview:_backgroundView atIndex:0];
}

- (void)initButtonWithImage:(NSString *)imageName
                      label:(NSString *)string
                        tag:(eSocialButtonType)buttonType
                      index:(NSInteger)index
                      totalLength:(CGFloat)width
{
    CGFloat gap = (width - 132)/4;
    CGFloat offSetX =  index * (gap + 44);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:buttonType];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(gap + offSetX, 50, 44, 44)];
    
    OSSocialLabel *label = [[OSSocialLabel alloc] initWithFrame:CGRectMake(0, 0, 70 , 20)];
    [label setCenter:CGPointMake(button.center.x, button.center.y + 32)];
    [label setText:string];
    [_backgroundView addSubview:button];
    [_backgroundView addSubview:label];
}

- (void)cancelButtonAction:(UIButton *)button
{
    [self hiddenAnimation];
}

- (void)shareButtonAction:(UIButton *)button
{
    switch (button.tag) {
        case eWechatButtonType:
        {
            [self shareWithWechat];
            break;
        }
        case eWechatFriendButtonType:
        {
            [self shareWithWeChatFriend];
            break;
        }
        case eWeiboButtonType:
        {
            [self shareWithWeibo];
            break;
        }
        default:
            break;
    }
}

- (void)shareWithWechat
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        // 分享
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneSession;
        //    req.bText = NO;
        req.message = WXMediaMessage.message;
     
        //
        req.message.title = @"推荐应用\"一秒\"给你";
        req.message.description = @"前往App Store下载，开始记录最美的时光吧！";
     
        [self setThumbImage:req];
      
        WXWebpageObject *webObject = WXWebpageObject.object;
        webObject.webpageUrl = @"https://itunes.apple.com/us/app/yi-miao-ji-lu-zui-mei-shi-guang/id1069756461?l=zh&ls=1&mt=8";
        req.message.mediaObject = webObject;
        
        // 支付宝
        // https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-zhifubao/id333206289?mt=8
        // id333206289
        // 一秒
        // https://itunes.apple.com/us/app/yi-miao-ji-lu-zui-mei-shi/id1069756461?l=zh&ls=1&mt=8
        // id1069756461
        // 品而金融
        // https://itunes.apple.com/us/app/pin-er-jin-rong/id1032490261?l=zh&ls=1&mt=8
        // id1032490261
        
        // App Store地址
        // https://itunes.apple.com/cn/app/id923680802
        
        //        WXImageObject *imageObject = WXImageObject.object;
//        imageObject.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"leftSidebar.png"], 1);
//        req.message.mediaObject = imageObject;
    
        [WXApi sendReq:req];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到您未安装微信，暂时无法分享。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setThumbImage:(SendMessageToWXReq *)req
{
    UIImage *image = [UIImage imageNamed:@"roundLogo"];
    if (image) {
//        CGFloat width = 200.0f;
//        CGFloat height = image.size.height * 200.0f / image.size.width;
//        UIGraphicsBeginImageContext(CGSizeMake(width, height));
//        [image drawInRect:CGRectMake(0, 0, width, height)];
//        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        [req.message setThumbImage:image];
    }
}

- (void)shareWithWeChatFriend
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        // 分享
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.scene = WXSceneTimeline;
        //    req.bText = NO;
        req.message = WXMediaMessage.message;
        
        req.message.title = @"推荐应用\"一秒\"给大家，开始记录最美的时光吧！";
        
        [self setThumbImage:req];
        
        WXWebpageObject *webObject = WXWebpageObject.object;
        webObject.webpageUrl = @"https://itunes.apple.com/us/app/yi-miao-ji-lu-zui-mei-shi-guang/id1069756461?l=zh&ls=1&mt=8";
        req.message.mediaObject = webObject;
        
//        WXImageObject *imageObject = WXImageObject.object;
//        imageObject.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"7.jpg"], 1);z
//        req.message.mediaObject = imageObject;
        
        [WXApi sendReq:req];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到您未安装微信，暂时无法分享。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareWithWeibo
{
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP]) {
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:nil access_token:@"d3b35c403311cca19597b6cee0a9ccc1"];
        [WeiboSDK sendRequest:request];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到您未安装微博，暂时无法分享。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *shareObject = [[WBMessageObject alloc] init];
  
//    if (image != nil) {
//        WBImageObject *imageObject = [WBImageObject object];
//        imageObject.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"leftSidebar.png"]);
//        shareObject.imageObject = imageObject;
//    }
    
//    if (url != nil) {
//        NSString *urlString = url.absoluteString;
    
    // 短域名 ：http://t.cn/RGurTgH
        shareObject.text = [NSString stringWithFormat:@"推荐应用\"一秒\"给大家，开始记录最美的时光吧！前往App Store下载（请用Safari打开）：https://itunes.apple.com/us/app/yi-miao-ji-lu-zui-mei-shi-guang/id1069756461?l=zh&ls=1&mt=8"];
//    shareObject.text = @"https://itunes.apple.com/us/app/pin-er-jin-rong/id1032490261?l=zh&ls=1&mt=8";
//    shareObject.text = @"http://t.cn/RGB9xOn";
    
//    }
    return shareObject;
}

#pragma mark --------------- 功能函数 --------------------------
- (void)showAnimation
{
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGRect frame = self.backgroundView.frame;
//        frame.origin.y = DEVICE_HEIGHT - 240.5f;
//        self.backgroundView.frame = frame;
//        
//        [self showCoverViewWithContentView:self isHideWhenTouchBackground:NO];
//    } completion:^(BOOL finished) {
//        
//    }];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_backgroundView.layer addAnimation:animation forKey:nil];

    self.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
        }];
}

- (void)hiddenAnimation
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    //        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    animation.values = values;
    [_backgroundView.layer addAnimation:animation forKey:nil];

    self.alpha = 1.0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = .0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark --------------- 接口API --------------------------
/**
 * 从屏幕中央上弹出一个ActionSheet样式的分享列表(可以直接在文字中添加URL信息)
 * @param  需要显示分享的Controller
 * @param  需要分享的文字
 */
+ (void)showSocialSharePanelWith:(UIViewController *)viewController shareContext:(NSString *)string
{
    OSShareView *shareView = [[OSShareView alloc] initWithFrame:CGRectMake(30, (DEVICE_HEIGHT - 200)/2, DEVICE_WIDTH - 60, 200)];
    [viewController.view addSubview:shareView];
    
    // 准备文字
    
    [shareView showAnimation];
}

/**
 * 从屏幕中央弹出一个ActionSheet样式的分享列表(可以直接在文字中添加URL信息)
 * @param  需要显示分享的Controller
 * @param  需要分享的标题（可选）
 * @param  需要分享的文字（可选）
 * @param  需要分享的图片（可选）
 * @param  需要分享的URL（可选,为如下格式"http://www.pierup.cn"）
 */
+ (void)showSocialSharePanelWith:(UIViewController *)viewController shareTitle:(NSString *)title shareContext:(NSString *)string imageData:(UIImage *)image url:(NSString *)url
{

}

@end
