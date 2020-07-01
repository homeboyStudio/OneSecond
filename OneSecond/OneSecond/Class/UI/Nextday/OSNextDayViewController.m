//
//  OSNextDayViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/25.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSNextDayViewController.h"
#import "OSNetwork.h"
#import "OSUserBean.h"
#import "OSNextDayModel.h"
#import "UIImageView+WebCache.h"
#import "OSDateUtil.h"
#import "OSNextDayViewModel.h"
#import "NSString+Check.h"
#import "OSMusicPlayer.h"
#import "THLabel.h"
#import "OSSideMenuController.h"
#import "SIAlertView.h"
#import "WeixinActivity.h"
#import "WeiboShareActivity.h"

#define animationDuration 0.35f
#define musicBGAlpha  0.7

@interface OSNextDayViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *nextDayIamgeView;

@property (nonatomic, weak) IBOutlet UIImageView *videoImageView;
@property (nonatomic, strong) AVPlayer *player;                       // 播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer;             // 显示窗口
@property (nonatomic, assign) BOOL isShowOnWindow;

@property (nonatomic, weak) IBOutlet UIView *frontBgView;
@property (nonatomic, weak) IBOutlet UIView *musicBgView;

@property (nonatomic, weak) IBOutlet THLabel *dayBigLabel;             // 21
@property (nonatomic, weak) IBOutlet THLabel *dateLabel;               // 时间，DEC.TUESDAY, 事件

@property (nonatomic, weak) IBOutlet THLabel *reverseLabel;            // 地理位置
@property (nonatomic, weak) IBOutlet UILabel *textLabel;               // 文艺

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet THLabel *musicTitleLabel;         // 音乐标题
@property (nonatomic, weak) IBOutlet THLabel *musicArtistLabel;        // 音乐作者
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;     // 播放进度
@property (nonatomic, assign) BOOL isProgressViewHidden;
@property (nonatomic, assign) BOOL isAllWidgetHidden;
@property (nonatomic, assign) BOOL isCellularPlay;                     // 是否在蜂窝网下播放

@property (nonatomic, strong) OSMusicPlayer *musicPlayer;              // 播放器

@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;         // 分享图片作者

@property (nonatomic, weak) IBOutlet UIButton *shareButton;            // 分享按钮

@property (nonatomic, strong) SDWebImageManager *imageManager;
@property (nonatomic, strong) OSUserBean *userBean;
@property (nonatomic, strong) OSNextDayModel *nextDayModel;
@property (nonatomic, strong) OSNextDayViewModel *nextDayViewModel;   // ViewModel

@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSDate *date;


// 约束
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textLabelRightLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textLabelheightLayout;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoImageViewTopLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoImageViewLeftLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoImageViewBottomLayout;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoImageViewRightLayout;

@property (nonatomic, strong) UIImage *cutViewImage; // 屏幕截图

@end

@implementation OSNextDayViewController

#pragma mark ----------- 初始化 ---------------------
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userBean = [[OSUserBean alloc] init];
        self.nextDayViewModel = [[OSNextDayViewModel alloc] init];
        self.musicPlayer = [[OSMusicPlayer alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化日期
    _dateString = self.inputDateStr;
    _date = self.inputDate;
    
    //初始化UI
    [self setupUI];
    
    //连接网络，获得NextDay的内容
    [self getNextDayService];

    //隐藏所有控件
    [self hiddenAllWidget];
    
    //初始化SDWebImageManager
    _imageManager = [SDWebImageManager sharedManager];
    //设置占用内存上限
    [_imageManager.imageCache setMaxMemoryCountLimit:3];
    
    if (__dataSource.networkType == eNetworkType_None) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"网络好像断开了，请先检查网络。"];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        alertView.enabledParallaxEffect = NO;
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }else {
        [self getNextDayService];
    }
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidEnterBackground
{
     OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [menuController hideRightViewAnimated:YES completionHandler:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [self.musicPlayer playerWillAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.musicPlayer playerDidDisappear];
}

#pragma mark --------------- 功能函数 ------------------------

- (void)setupUI
{
    self.isAllWidgetHidden = NO;
    
    [self.osNavigationController setNavigationBarBackgroundAlpha:0.0f];
    [self.osNavigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    
    // 初始化视频播放
    _isShowOnWindow = NO;
    AVPlayerItem *playerItem = [OSNextDayViewModel getPlayItemWithVideoUrlString:@""];
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 判断是否为4s,更改屏幕尺寸
    
      //  100  [10 80 10]       -10 100  10
    if ([OSDevice isDeviceIPhone4s]) {
        [_playerLayer setFrame:CGRectMake(-50, -70, DEVICE_WIDTH + 50, DEVICE_HEIGHT + 178)];
    }else {
        [_playerLayer setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    }
    
    [_videoImageView.layer addSublayer:_playerLayer];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoImageViewTapAction)];
    gestureRecognizer.numberOfTapsRequired = 1;  // tap次数
    [self.videoImageView addGestureRecognizer:gestureRecognizer];
    
    // 设置几号，月份和星期
    [self.dayBigLabel setText:[_nextDayViewModel getBigDayWithDate:_dateString]];
    [self.dateLabel setText:[_nextDayViewModel getDateStringWithDate:_date String:_dateString event:nil]];
    
    // 配置属性
    // 日期
    // #919192
    [self.dayBigLabel setFont:[OSFont nextDayThinFontWithSize:HighlightNumberFontSize + 70]];
    self.dayBigLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.4];
    self.dayBigLabel.shadowOffset = CGSizeMake(0.5, 1.5);
    self.dayBigLabel.shadowBlur = 2.0f;
    [self.dayBigLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self.dateLabel setFont:[OSFont nextDayFontWithSize:HighlightFontSize]];
    self.dateLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.5];
    self.dateLabel.shadowOffset = CGSizeMake(0.5, 1.3);
    self.dateLabel.shadowBlur = 2.0f;

    // 文案
    [self.reverseLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    self.reverseLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.7];
    self.reverseLabel.shadowOffset = CGSizeMake(0.5, 1.3);
    self.reverseLabel.shadowBlur = 2.0f;

    [self.textLabel setFont:[OSFont nextDayFontWithSize:ExplanatoryFontSize]];
    [self.textLabel setAdjustsFontSizeToFitWidth:YES];
    
    // 音乐
    [self.musicTitleLabel setFont:[OSFont nextDayFontWithSize:ExplanatoryFontSize]];
    self.musicTitleLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.6];
    self.musicTitleLabel.shadowOffset = CGSizeMake(0.5, 1.3);
    self.musicTitleLabel.shadowBlur = 2.0f;

    [self.musicArtistLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize - 1]];
    self.musicArtistLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.6];
    self.musicArtistLabel.shadowOffset = CGSizeMake(0.5, 1.3);
    self.musicArtistLabel.shadowBlur = 2.0f;

    self.musicPlayer.playerProgressView = _progressView;
    
    [self.progressView setTrackTintColor:[OSColor colorFromHex:@"#FFFFFF" alpha:0.2]];
    [self.progressView setProgressTintColor:[OSColor pureWhiteColor]];
    
    // 分享图片作者
    [self.authorNameLabel setTextColor:[OSColor colorFromHex:@"#ACABAC" alpha:0.8]];
    [self.authorNameLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontBgViewTapAction)];
    tapGestureRecognizer.numberOfTapsRequired = 1;  // tap次数
    [self.frontBgView addGestureRecognizer:tapGestureRecognizer];
}

- (void)updateUI {
    
    //更新日期
    _dateString = self.inputDateStr;
    _date = self.inputDate;
    
    //更新文字标签
    [self.dayBigLabel setText:[_nextDayViewModel getBigDayWithDate:_dateString]];
    [self.dateLabel setText:[_nextDayViewModel getDateStringWithDate:_date String:_dateString event:nil]];
    
    //连接网络，重新获取NextDay的内容
    [self getNextDayService];
}

- (void)cleanUpUI {
    [self.dayBigLabel setText:nil];
    [self.dateLabel setText:nil];
    [self.reverseLabel setText:nil];
    [self.textLabel setText:nil];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.musicTitleLabel setText:nil];
    [self.musicArtistLabel setText:nil];
    [self.authorNameLabel setText:nil];
    [self.nextDayIamgeView setImage:nil];
    self.videoImageView.hidden = YES;
}


- (void)setupFullInformation
{
    [self showAllWidget];
    
    // 根据机型加载不同尺寸的图片
    NSString *imageUrlString = @"";
    if ([OSDevice isDeviceIPhone4s]) {
        imageUrlString = _nextDayModel.imagesModel.big2x;
    }else if ([OSDevice isDeviceIPhone5] || [OSDevice isDeviceIPhone6]) {
        imageUrlString = _nextDayModel.imagesModel.big568h2x;
    }else {
        imageUrlString = _nextDayModel.imagesModel.big568h3x;
    }
    
    [_imageManager downloadImageWithURL:[NSURL URLWithString:imageUrlString] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        [self.nextDayIamgeView setAlpha:0.0f];
        [UIView transitionWithView:self.nextDayIamgeView duration:animationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.nextDayIamgeView setImage:image];
            [self.nextDayIamgeView setAlpha:1.0f];
        } completion:^(BOOL finished) {
           // 下载完成图片后可以保存图片到相册之中  置为可以保存图像
            // 异步截取图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cutViewImage = [self imageWithView:self.view];
                // 可交互状态
                    [self.frontBgView setUserInteractionEnabled:YES];
                });
            });
        }];
    }];
    
    

    // event
    if (![NSString emptyOrNull:_nextDayModel.event]) {
        [self.dateLabel setText:[_nextDayViewModel getDateStringWithDate:self.inputDate String:self.inputDateStr event:_nextDayModel.event]];
    }
    
    // 地理位置 reverse
    [self.reverseLabel setText:_nextDayModel.reverse];
    
    // short comment
    // 背景颜色
    [self.textLabel setBackgroundColor:[OSColor colorFromHex:_nextDayModel.background alpha:1.0f]];
    
    NSString *textString = [NSString stringWithFormat:@" %@",_nextDayModel.textModel.shortComment];
    
    CGFloat width = [self widthForString:textString font:[OSFont customFontWithSize:ExplanatoryFontSize] andHeight:50.0f];
//    CGFloat height = [self heightForString:textString font:[OSFont customFontWithSize:ExplanatoryFontSize]];
    if (width < (DEVICE_WIDTH - 30)) {
        // 改变约束
        _textLabelRightLayout.constant = DEVICE_WIDTH - 13 - width;
    }
//    if ([OSDevice isDeviceIPhone4s]) {
//        self.textLabelheightLayout.constant = 15;
//    }else if ([OSDevice isDeviceIPhone5]) {
//        self.textLabelheightLayout.constant = 15;
//    }
    [self.textLabel setText:textString];
    
    // 音乐
    [self.musicTitleLabel setText:_nextDayModel.musicModel.title];
    [self.musicArtistLabel setText:_nextDayModel.musicModel.artist];
    
    // 初始化音乐信息
    _musicPlayer.playItem.title = _nextDayModel.musicModel.url;
    _musicPlayer.playItem.url = [NSURL URLWithString:_nextDayModel.musicModel.url];
    
    // 作者信息
    if (![NSString emptyOrNull:_nextDayModel.authorName]) {
        [_authorNameLabel setText:[NSString stringWithFormat:@"@%@",_nextDayModel.authorName]];
    }else {
        [_authorNameLabel setHidden:YES];
    }
    
    if (_nextDayModel.videoModel != nil) {
        // 视频
        AVPlayerItem *playerItem = [OSNextDayViewModel getPlayItemWithVideoUrlString:_nextDayModel.videoModel.url];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        // 添加通知
        [self addNotification];
        [self.player play];
    }
}

- (float)widthForString:(NSString *)value font:(UIFont *)font andHeight:(CGFloat)height
{
//    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:font}];
    CGSize sizeToFit = [value sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat width = sizeToFit.width;
    return width;
}

- (float)heightForString:(NSString *)value font:(UIFont *)font
{
    CGSize sizeToFit = [value sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat height = sizeToFit.height;
    return height;
}


- (void)hiddenAllWidget
{
    [self.videoImageView setHidden:YES];
    [self.musicBgView setHidden:YES];
    
    [self.reverseLabel setHidden:YES];
    [self.textLabel setHidden:YES];
    
    [self.playButton setHidden:YES];
    [self.musicTitleLabel setHidden:YES];
    [self.musicArtistLabel setHidden:YES];
    
    [self.progressView setHidden:YES];
    self.isProgressViewHidden = YES;
    
    [self.authorNameLabel setHidden:YES];

}

- (void)showAllWidget
{
    if (_nextDayModel.videoModel != nil) {
        [self.videoImageView setHidden:NO];
    }
    
    [self.musicBgView setHidden:NO];
    
    [self.reverseLabel setHidden:NO];
    [self.textLabel setHidden:NO];
    
    [self.playButton setHidden:NO];
    [self.musicTitleLabel setHidden:NO];
    [self.musicArtistLabel setHidden:NO];
//    [self.progressView setHidden:YES];
    
    [self.authorNameLabel setHidden:NO];

    [self.videoImageView setAlpha:0];
    
    [self.musicBgView setAlpha:0];
    [self.reverseLabel setAlpha:0];
    [self.textLabel setAlpha:0];
    
    [self.playButton setAlpha:0];
    [self.musicTitleLabel setAlpha:0];
    [self.musicArtistLabel setAlpha:0];
    
    [self.authorNameLabel setAlpha:0];

    [UIView animateWithDuration:animationDuration animations:^{
        [self.videoImageView setAlpha:1.0];
        
        [self.musicBgView setAlpha:musicBGAlpha];
        [self.reverseLabel setAlpha:1.0];
        [self.textLabel setAlpha:1.0];
        
        [self.playButton setAlpha:1.0];
        [self.musicTitleLabel setAlpha:1.0];
        [self.musicArtistLabel setAlpha:1.0];
        
        [self.authorNameLabel setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}


-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification
{
    [self removeNotification];
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addNotification];
    [self.player play];
}

- (void)applicationWillEnterForeground
{
    [self.player play];
}

#pragma mark --------------- service ------------------------

- (void)getNextDayService
{
    NSString *date = [OSDateUtil getStringDate:_inputDate formatType:SIMPLEFORMATTYPE14];
    if ([date isEqualToString:@"2019/11/10"]) {
        // 有视频推送的日历
        date = @"2016/04/28";
    }
    self.userBean.dateString = date;
    OSNetwork *network = [[OSNetwork alloc] init];

    __weak typeof(self) weakSelf = self;
    [network serverSend:SERVICE_USER_NEXTDAY bean:self.userBean successBlock:^(NSURLSessionDataTask *task) {

        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.nextDayModel = [strongSelf.nextDayViewModel convertToNextDayModel:strongSelf.userBean.nextDayModel.resultJsonModel];
        // 配置其他属性
        [strongSelf setupFullInformation];

    } failedlock:^(NSURLSessionDataTask *task, NSError *error) {
//        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"服务器正在更新数据，请稍后再试。"];
//        [alertView addButtonWithTitle:@"确定"
//                                 type:SIAlertViewButtonTypeDefault
//                              handler:^(SIAlertView *alertView) {
//                                  
//                              }];
//        alertView.enabledParallaxEffect = NO;
//        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
//        [alertView show];
    }];
}

#pragma mark ---------- 按钮事件 ------------------------
- (IBAction)playMusicButtonAction:(UIButton *)sender
{
    if (__dataSource.networkType == eNetworkType_Cellular && !_isCellularPlay) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"流量提示" andMessage:@"检测到您处在非Wi-Fi环境下，操作可能会产生一定的流量，是否继续播放？"];
        [alertView addButtonWithTitle:@"继续"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  self.isCellularPlay = YES;
                                  [self.progressView setHidden:NO];
                                  self.isProgressViewHidden = NO;
                                  [self.musicPlayer play:sender andProgressView:self.progressView];
                                  return;
                              }];
        
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  return;
                              }];
        alertView.enabledParallaxEffect = NO;
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];

    }else {
        [self.progressView setHidden:NO];
        self.isProgressViewHidden = NO;
        [self.musicPlayer play:sender andProgressView:self.progressView];
    }
}

- (IBAction)shareButtonSaveImageAvtion:(UIButton *)sender
{
    NSString *textToShare = [NSString emptyOrNull:_textLabel.text] ? @"分享来自一秒" : _textLabel.text;
    UIImage *imageToShare = _nextDayIamgeView.image;
    NSArray *activityItems = @[textToShare, imageToShare];
    
    WeiboShareActivity *weiboShareActivity = [[WeiboShareActivity alloc] init];
    WeixinSessionActivity *weixinSessionActivity = [[WeixinSessionActivity alloc] init];
    WeixinTimelineActivity *weixinTimelineActivity = [[WeixinTimelineActivity alloc] init];
    if (_cutViewImage != nil) {
        weiboShareActivity.cutImage = _cutViewImage;
        weixinSessionActivity.cutImage = _cutViewImage;
        weixinTimelineActivity.cutImage = _cutViewImage;
    }
    // 分享菜单
    NSArray *weixinArray = @[weiboShareActivity, weixinSessionActivity, weixinTimelineActivity];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:weixinArray];
    
    NSArray *array = nil;
    
    if (IOS_9_OR_LATER()) {
        array = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeOpenInIBooks];
    }else {
        array = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo];
    }
    
    activityViewController.excludedActivityTypes = array;
    [self.osNavigationController presentViewController:activityViewController animated:YES completion:^{
        
    }];
    // 保存到相册
//    [_nextDayViewModel saveImageToPhotoWithImage:_nextDayIamgeView.image];
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark ---------- 手势事件 ------------------------
- (void)frontBgViewTapAction
{
    CGFloat alphaStart = 0;
    CGFloat alphaEnd = 1;
    
    CGFloat alphaMusicStart = 0;
    CGFloat alphaMusicEnd = 0.5;
    if (self.isAllWidgetHidden) {
        self.isAllWidgetHidden = !self.isAllWidgetHidden;
        // 显现动画
        
        alphaStart = 0;
        alphaEnd = 1;
        
        alphaMusicStart = 0;
        alphaMusicEnd = musicBGAlpha;

    }else {
        self.isAllWidgetHidden = !self.isAllWidgetHidden;
        // 隐藏动画
        alphaStart = 1;
        alphaEnd = 0;
        
        alphaMusicStart = musicBGAlpha;
        alphaMusicEnd = 0.0;
    }
    
    [self.videoImageView setAlpha:alphaStart];
    
    [self.musicBgView setAlpha:alphaMusicStart];
    
    [self.dayBigLabel setAlpha:alphaStart];
    [self.dateLabel setAlpha:alphaStart];
    
    [self.reverseLabel setAlpha:alphaStart];
    [self.textLabel setAlpha:alphaStart];
    
    [self.playButton setAlpha:alphaStart];
    [self.musicTitleLabel setAlpha:alphaStart];
    [self.musicArtistLabel setAlpha:alphaStart];
    
    [self.progressView setAlpha:alphaStart];
    
    [self.authorNameLabel setAlpha:alphaStart];
    
    // 分享按钮
    [self.shareButton setAlpha:alphaEnd];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.videoImageView setAlpha:alphaEnd];

        [self.musicBgView setAlpha:alphaMusicEnd];
        
        [self.dayBigLabel setAlpha:alphaEnd];
        [self.dateLabel setAlpha:alphaEnd];
        
        [self.reverseLabel setAlpha:alphaEnd];
        [self.textLabel setAlpha:alphaEnd];
        
        [self.playButton setAlpha:alphaEnd];
        [self.musicTitleLabel setAlpha:alphaEnd];
        [self.musicArtistLabel setAlpha:alphaEnd];
        
        [self.progressView setAlpha:alphaEnd];
        
        [self.authorNameLabel setAlpha:alphaEnd];
        
        // 分享按钮
        [self.shareButton setAlpha:alphaStart];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)videoImageViewTapAction
{
    if (!_isShowOnWindow) {
        _isShowOnWindow = YES;
    
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            // 改变约束
            self.videoImageViewTopLayout.constant = 15;
            self.videoImageViewRightLayout.constant = 15;
            self.videoImageViewLeftLayout.constant = DEVICE_WIDTH * 0.8 - 15;
            self.videoImageViewBottomLayout.constant = DEVICE_HEIGHT * 0.8 - 15;
    
            [self.playerLayer setFrame:CGRectMake(0, 0, DEVICE_WIDTH * 0.2, DEVICE_HEIGHT * 0.2)];
            
            [self.videoImageView setNeedsLayout];
        } completion:^(BOOL finished) {
            
        }];
    }else {
        _isShowOnWindow = NO;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            // 改变约束
            self.videoImageViewTopLayout.constant = 0;
            self.videoImageViewRightLayout.constant = 0;
            self.videoImageViewLeftLayout.constant = 0;
            self.videoImageViewBottomLayout.constant = 0;
            
            if ([OSDevice isDeviceIPhone4s]) {
                [self.playerLayer setFrame:CGRectMake(-50, -70, DEVICE_WIDTH + 50, DEVICE_HEIGHT + 178)];
            }else {
                [self.playerLayer setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            }
            
            [self.videoImageView setNeedsLayout];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark ---------- 退出清空 ------------------------

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
