//
//  OSVideoClipViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 16/1/28.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import "OSVideoClipViewController.h"
#import "OSSideMenuController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SIAlertView.h"
#import "OSVideoClipViewModel.h"
#import "MBProgressHUD.h"
#import "SIAlertView.h"

@interface OSVideoClipViewController ()<OSVideoClipViewModelDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
// @property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@property (nonatomic, weak) IBOutlet UIButton *saveToPhotoButton;
@property (nonatomic, weak) IBOutlet UILabel *saveLabel;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

@property (nonatomic, strong) AVQueuePlayer *queuePlayer;  // 播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer;  // 播放器窗口
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL isPlaying;     // 影片是否正在播放

@property (nonatomic, assign) float duration;   // 影片持续时间
@property (nonatomic, assign) float current;    // 影片当前时间

@property (nonatomic, strong) OSVideoClipViewModel *videoClipViewModel;
@property (nonatomic, weak) OSSideMenuController *menuController;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OSVideoClipViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videoClipViewModel = [[OSVideoClipViewModel alloc] init];
        self.videoClipViewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setContentView];

    [self setContentData];
    
    [self setBackBarButtonItemHidden:YES];
    [self setLeftBarButtonItemHidden:YES];
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.osNavigationController setNavigationBarHidden:YES animated:YES];  // 隐藏导航栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [_menuController setLeftViewSwipeGestureEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.osNavigationController setNavigationBarHidden:NO animated:YES];  // 显示导航栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [_menuController setLeftViewSwipeGestureEnabled:YES];
}

- (void)setContentView
{
    CGFloat deviceWidth = DEVICE_WIDTH;
    CGFloat videoHeight = (deviceWidth*4)/3;
    CGFloat deviceHeight = DEVICE_HEIGHT;
    
    [self.backgroundImageView setFrame:CGRectMake(0, 0, deviceWidth, videoHeight)];
    [self.playButton setFrame:CGRectMake((deviceWidth - 60)/2, (videoHeight - 60)/2, 60, 60)];
//    [self.playButton setHidden:YES];
    [self.playButton setAlpha:0.0f];
    [self.backButton setAlpha:0.0f];
    
    [self.backButton setBackgroundColor:[OSColor colorFromHex:@"191919" alpha:.7f]];
    [self.backButton.layer setCornerRadius:20.0];
    
//    [self.progressView setFrame:CGRectMake(0,videoHeight, deviceWidth, 1)];
//    [self.progressView setProgressTintColor:[OSColor specialorangColor]];
    // #707180
//    [self.progressView setTrackTintColor:[OSColor skyBlueColor]];
//    [self.progressView setTrackTintColor:[OSColor colorFromHex:@"#707180" alpha:0.5]];
    
    CGFloat buttonHeight = 70;
    CGFloat offSet = 0;
    if ([OSDevice isDeviceIPhone4s]) {
        buttonHeight = 40.0;
        offSet = 6.0f;
    }
    
    [self.saveToPhotoButton setFrame:CGRectMake((deviceWidth - buttonHeight)/2, (deviceHeight - videoHeight - buttonHeight)/2 + videoHeight - offSet, buttonHeight, buttonHeight)];
    [self.saveLabel setFrame:CGRectMake(0, CGRectGetMaxY(_saveToPhotoButton.frame), deviceWidth, 20 - offSet)];
    [self.saveLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    [self.saveLabel setTextColor:[OSColor specialGaryColor]];
    
    // 触摸事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction)];
    [self.backgroundImageView addGestureRecognizer:tapGestureRecognizer];

    _menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    _isPlaying = NO;
  
     // 3. 初始化AVPlayerLayer 显示视频
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:nil];
    [_playerLayer setFrame:CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH*4)/3)];
    [_backgroundImageView.layer addSublayer:_playerLayer];

}

// 初始化数据
- (void)setContentData
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    //        hud.color = [UIColor clearColor];
    AMTumblrHud *tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.view.frame.size.width - 55) * 0.5),
                                                                           (CGFloat) ((self.view.frame.size.height - 20) * 0.5), 55, 20)];
    tumblrHUD.hudColor = [OSColor specialGaryColor];
    [tumblrHUD showAnimated:YES];
    hud.labelText = @"正在处理";
    [hud setLabelFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    [hud setLabelColor:[OSColor pureDarkColor]];
    [hud setColor:[OSColor pureWhiteColor]];
    hud.customView = tumblrHUD;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];

    [self.videoClipViewModel getPlayerItemsWithBlock:^(NSArray *itemsArray, float duration) {
        if (itemsArray.count > 0) {
//            [self.playButton set:NO];
            [self showPlayButtonAndBackButtonAnimation];
            _queuePlayer = [AVQueuePlayer queuePlayerWithItems:itemsArray];
            [_playerLayer setPlayer:_queuePlayer];
            self.duration = duration;
            self.current = 0;
            [hud hide:YES];
        }else {
            [self.backButton setAlpha:1.0f];
            
            [hud hide:YES];
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"啊哦，好像出问题了，暂时无法获得数据源，请退出后重试。"];
            [alertView addButtonWithTitle:@"好的"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      
                                  }];
        }
    }];
}

#pragma mark -------- 手势事件 -----------------
- (void)tapImageViewAction
{
//        if(self.queuePlayer.rate == 0){ //说明时暂停
//    //        [sender setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
//            [self.queuePlayer play];
//        }else
    if(self.queuePlayer.rate == 1){//正在播放
        [self.queuePlayer pause];
//        [self.playButton setHidden:NO];
//        [self.backButton setHidden:NO];
        [self showPlayButtonAndBackButtonAnimation];
        //        [sender setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }
}

#pragma mark ------------ 按钮事件 -----------------------
- (IBAction)playButtonClicked:(UIButton *)sender
{
    if (!_isPlaying) {
        _isPlaying = YES;
//        [self.progressView setProgress:0.0f];
        // 先移除通知
        [self removeNotification];
//        [self removeObserverFromPlayerItem:self.player.currentItem];
        
        // 重新播放
//        AVPlayerItem *playerItem = [_clipViewModel getPlayItemWithVideoUrlString:self.oneString];
        
        
//        [self.queuePlayer replaceCurrentItemWithPlayerItem:playerItem];
        
        // 添加通知
        [self addNotification];
        // 添加KVO
//        [self addObserverToQueuePlayer:self.queuePlayer];
        
//        [self addProgessObserver];
        
        [self.queuePlayer play];
//        [self.playButton setHidden:YES];
        [self hidePlayButtonAndBackButtonAnimation];
    }else {
        if(self.queuePlayer.rate == 0) {
            //正在播放
            [self.queuePlayer play];
//            [self.playButton setHidden:YES];
            [self hidePlayButtonAndBackButtonAnimation];
        }
    }

    [_queuePlayer play];
}

- (IBAction)saveToPhotoButtonClicked:(UIButton *)sender
{
    // 1.首先询问用户是否要导出到相册当中
    // 2.检查用户全选是否允许
    ALAuthorizationStatus author =  [ALAssetsLibrary authorizationStatus];
    switch (author) {
        case ALAuthorizationStatusNotDetermined:
        {
            // 还未被询问
             [[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频剪辑完成后请允许应用访问\"照片\"权限，确定将视频剪辑导出到本地吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil] show];
            break;
        }
        case ALAuthorizationStatusRestricted:
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您未允许应用访问\"照片\"权限，请到系统设置-隐私-照片-允许一秒访问，来继续导出视频操作。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            // 拒绝
            break;
        }
        case ALAuthorizationStatusDenied:
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您未允许应用访问\"照片\"权限，请到系统设置-隐私-照片-允许一秒访问，来继续导出视频操作。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            break;
        }
        case ALAuthorizationStatusAuthorized:
        {
//            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"是否需要导出到本地相册？"];
//            [alertView addButtonWithTitle:@"确定"
//                                     type:SIAlertViewButtonTypeDefault
//                                  handler:^(SIAlertView *alertView) {

//                                      }];
//
//            [alertView addButtonWithTitle:@"取消"
//                                     type:SIAlertViewButtonTypeCancel
//                                  handler:^(SIAlertView *alertView) {
//                                      
//                                  }];
//            
//            alertView.enabledParallaxEffect = NO;
//            alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
//            [alertView show];
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定将视频剪辑导出到本地吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil] show];
            // 允许
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 开启HUD
        _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:_hud];
        // Set determinate mode
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.delegate = self;
        [_hud setLabelFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
        [_hud setLabelColor:[OSColor pureWhiteColor]];
        _hud.labelText = @"准备渲染";
        [_hud show:YES];
        
        if(self.queuePlayer.rate == 1) {
            //正在播放
            [self.queuePlayer pause];
            [self showPlayButtonAndBackButtonAnimation];
        }

        // 保存到相册中
        // 元数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.videoClipViewModel startMergeVideo];
        });
    }
}
- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.osNavigationController popViewControllerAnimated:YES];
}

#pragma mark ------------- 功能函数 -----------------------
- (void)addProgessObserver
{
//    __block UIProgressView *progress = self.progressView;
//    __block float total = self.duration;
//    __block float current = 0;
//    [self.queuePlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 25.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        CGFloat current = CMTimeGetSeconds(time);
//        if (current) {
//            [progress setProgress:(current/total) animated:YES];
//        }
//    }];
}

- (void)addObserverToQueuePlayer:(AVQueuePlayer *)queuePlayer
{
//    [queuePlayer addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

// KVO
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    AVQueuePlayer *QueuePlayer = object;
//    if ([keyPath isEqualToString:@"rate"]) {
//        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
//        if (status == AVPlayerStatusReadyToPlay) {
//        
//        }
//    }
}

- (void)showPlayButtonAndBackButtonAnimation
{
    [UIView animateWithDuration:.4 animations:^{
        [self.playButton setAlpha:1.0];
        [self.backButton setAlpha:1.0];
    }];
}

- (void)hidePlayButtonAndBackButtonAnimation
{
    [UIView animateWithDuration:.4 animations:^{
        [self.playButton setAlpha:0.0f];
        [self.backButton setAlpha:0.0f];
    }];
}

#pragma mark ------------- 通知事件 -----------------------
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification *)notification
{
    // 播放完毕显示播放按钮
//    [self.playButton setHidden:NO];
//    _isPlaying = NO;
    _current = _current + 1;
    if (_current == _duration) {
//        [self.playButton setHidden:NO];
        [self showPlayButtonAndBackButtonAnimation];
        _isPlaying = NO;
        _current = 0;
        
//        [self.queuePlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
//            
//        }];
        [self setContentData];
    }
}

#pragma mark ---------- 代理事件 ----------------------------
- (void)mergeProgress:(CGFloat)progress
{
    // main thread 更新HUD进度
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud setProgress:progress];
        _hud.labelText = [NSString stringWithFormat:@"渲染进度:%.0f%%",progress*100];
    });
}

- (void)mergeResultWithError:(NSError *)error
{
    // 在这里关闭HUD
//    [_hud hide:YES afterDelay:0.0f];
    [_hud setHidden:YES];
    if (error == nil) {
        // 保存成功！！
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频成功导出到本地，请在照片中浏览。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"视频成功导出到本地，请在照片中浏览和分享。"];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        
        alertView.enabledParallaxEffect = NO;
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];

    } else {
        // 导出到相册中失败
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:error.localizedDescription];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        
        alertView.enabledParallaxEffect = NO;
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];

    }
}

// HUD delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    _hud = nil;
}

#pragma mark ---------- 退出清空 ----------------------------
- (void)dealloc
{
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
