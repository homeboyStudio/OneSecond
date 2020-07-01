//
//  OSMovieClipViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSMovieClipViewController.h"
#import "OSMovieClipViewModel.h"
#import "OSSideMenuController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SIAlertView.h"

@interface OSMovieClipViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;    // 播放器容器
@property (nonatomic, weak) IBOutlet UIButton *playButton;                // 播放按钮
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;        // 播放进度条

@property (nonatomic, weak) IBOutlet UIButton *saveToPhotoButton;
@property (nonatomic, weak) IBOutlet UILabel *saveLabel;

@property (nonatomic, strong) AVPlayer *player;                           // 播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer;                 // 显示窗口
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, strong) OSMovieClipViewModel *clipViewModel;        // ViewModel解耦逻辑
@property (nonatomic, copy) NSString *oneString;                          // 剪辑视频名称

@property (nonatomic, weak) OSSideMenuController *menuController;

@end

@implementation OSMovieClipViewController

#pragma mark --------- 初始化 -------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _clipViewModel = [[OSMovieClipViewModel alloc] init];
    }
    return self;
}

// 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setCustomTitle:@"" withColor:[UIColor blackColor]];
    
    [self setupUI];
    
     _menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    _isPlaying = NO;
    
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
    
    // 初始化数据
    [_clipViewModel startClipProgressWithBlock:^(BOOL success, NSError *error, NSString *filePathString) {
        
        [self.playButton setHidden:NO];
        
        self.oneString = filePathString;
        
        AVPlayerItem *playerItem = [_clipViewModel getPlayItemWithVideoUrlString:self.oneString];
        // 添加通知
        [self addNotification];
        // 添加KVO
        [self addObserverToPlayerItem:playerItem];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];

        [hud hide:YES];
    }];
    
    // 触摸事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction)];
    [self.backgroundImageView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.osNavigationController setNavigationBarHidden:YES animated:YES];  // 隐藏导航栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [_menuController setLeftViewSwipeGestureEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.osNavigationController setNavigationBarHidden:NO animated:YES];  // 显示导航栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    [_menuController setLeftViewSwipeGestureEnabled:YES];
}

- (void)setupUI
{
    CGFloat deviceWidth = DEVICE_WIDTH;
    CGFloat videoHeight = (deviceWidth*4)/3;
    CGFloat deviceHeight = DEVICE_HEIGHT;
    
    [self.backgroundImageView setFrame:CGRectMake(0, 0, deviceWidth, videoHeight)];
    [self.playButton setFrame:CGRectMake((deviceWidth - 60)/2, (videoHeight - 60)/2, 60, 60)];
    [self.playButton setHidden:YES];
    
    [self.progressView setFrame:CGRectMake(0,videoHeight, deviceWidth, 1)];
    [self.progressView setProgressTintColor:[OSColor specialorangColor]];
    [self.progressView setTrackTintColor:[OSColor colorFromHex:@"#707180" alpha:0.5]];
    
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
    
    // 1.初始化PlayerItem
    AVPlayerItem *playerItem = [_clipViewModel getPlayItemWithVideoUrlString:@""];
    // 2.初始化Player
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    // 3. 初始化AVPlayerLayer 显示视频
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [_playerLayer setFrame:CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH*4)/3)];
    [_backgroundImageView.layer addSublayer:_playerLayer];
    // 添加监听
//    [self addProgessObserver];
    // KVO 键值观察播放状态
//    [self addObserverToPlayerItem:playerItem];
}


#pragma mark -------- 功能函数 -----------------
- (void)addProgessObserver
{
    AVPlayerItem *playerItem = [_player currentItem];
    __block UIProgressView *progress = self.progressView;
    
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 25.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

// KVO
// 添加AVPlayerItem监控
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem
{
    // 监听状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

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
//    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            DLog(@"视频长度为%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }
}

// 移除KVO
- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem removeObserver:self forKeyPath:@"status"];
}

// 通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - --------------------通知事件--------------------

- (void)playbackFinished:(NSNotification *)notification
{
    // 播放完毕显示播放按钮
    [self.playButton setHidden:NO];
    _isPlaying = NO;
}

#pragma mark -------- 按钮事件 -----------------

- (IBAction)playButtonAction:(UIButton *)sender
{
    if (!_isPlaying) {
        _isPlaying = YES;
        [self.progressView setProgress:0.0f];
        // 先移除通知
        [self removeNotification];
        [self removeObserverFromPlayerItem:self.player.currentItem];
        
        // 重新播放
        AVPlayerItem *playerItem = [_clipViewModel getPlayItemWithVideoUrlString:self.oneString];
        
        
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        
        // 添加通知
        [self addNotification];
        // 添加KVO
        [self addObserverToPlayerItem:playerItem];
        [self addProgessObserver];
        
        [self.player play];
        [self.playButton setHidden:YES];
    }else {
        if(self.player.rate == 0) {
            //正在播放
            [self.player play];
            [self.playButton setHidden:YES];
        }
    }
}

- (IBAction)saveToPhotoLibraryButtonAction:(UIButton *)sender
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:self.oneString]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"啊哦，好像出问题了，暂时无法保存到相册中，请稍后重试。"];
                                        [alertView addButtonWithTitle:@"好的"
                                                                 type:SIAlertViewButtonTypeDefault
                                                              handler:^(SIAlertView *alertView) {
                                                                  
                                                              }];
                                        
                                        //        [alertView addButtonWithTitle:@"取消"
                                        //                                 type:SIAlertViewButtonTypeCancel
                                        //                              handler:^(SIAlertView *alertView) {
                                        //
                                        //                              }];
                                        
                                        alertView.enabledParallaxEffect = NO;
                                        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                                        [alertView show];
                                    } else {
                                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"视频已经成功保存到相册中了，您可以到相册中查看分享，记得保存好哦。"];
                                        [alertView addButtonWithTitle:@"好的"
                                                                 type:SIAlertViewButtonTypeDefault
                                                              handler:^(SIAlertView *alertView) {
                                                                  
                                                              }];
                                        //        [alertView addButtonWithTitle:@"取消"
                                        //                                 type:SIAlertViewButtonTypeCancel
                                        //                              handler:^(SIAlertView *alertView) {
                                        //
                                        //                              }];
                                        
                                        alertView.enabledParallaxEffect = NO;
                                        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                                        [alertView show];
                                    }
                                }];
}

#pragma mark -------- 手势事件 -----------------
- (void)tapImageViewAction
{
//    if(self.player.rate == 0){ //说明时暂停
////        [sender setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
//        [self.player play];
//    }else
        if(self.player.rate == 1){//正在播放
        [self.player pause];
        [self.playButton setHidden:NO];
//        [sender setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }
}

#pragma mark -------- 退出清空 -----------------

- (void)dealloc
{
    // 移除通知和KVO监听
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
