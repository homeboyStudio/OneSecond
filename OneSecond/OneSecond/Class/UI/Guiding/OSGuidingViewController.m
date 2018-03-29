//
//  OSGuidingViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/16.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSGuidingViewController.h"
#import "OSGuidingViewModel.h"
#import "OSGuidingView.h"
#import "OSGuidingSecondView.h"
#import "OSGuidingThirdView.h"
#import "OSGuidingFourthView.h"
#import "OSRecordingViewController.h"
#import "OSSideMenuController.h"

@interface OSGuidingViewController ()<UIScrollViewDelegate, OSGuidingFourthViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *backGroundView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIScrollView  *scrollView;

@property (nonatomic, strong) OSGuidingView *view1;
@property (nonatomic, strong) OSGuidingSecondView *view2;
@property (nonatomic, strong) OSGuidingThirdView *view3;
@property (nonatomic, strong) OSGuidingFourthView *view4;

@property (nonatomic, strong) AVPlayer *player;                           // 播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer;                 // 显示窗口
@property (nonatomic, copy) NSString *bundlePath;

@property (nonatomic, strong) OSGuidingViewModel *viewModel;

@end

@implementation OSGuidingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setupPlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark ------------------ 功能函数 -----------------------
- (void)setupUI
{
    [_scrollView setPagingEnabled:YES];
    [_scrollView setDelegate:self];
    [_scrollView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_scrollView setContentSize:CGSizeMake(DEVICE_WIDTH * 4, DEVICE_HEIGHT)];
    
    [_pageControl setFrame:CGRectMake(0, DEVICE_HEIGHT - 30, DEVICE_WIDTH, 20)];
    [_pageControl setNumberOfPages:4];
    
    _view1 = [OSGuidingView loadFromNib];
    [_view1 setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    _view2 = [OSGuidingSecondView loadFromNib];
    [_view2 setFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    _view3 = [OSGuidingThirdView loadFromNib];
    [_view3 setFrame:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    _view4 = [OSGuidingFourthView loadFromNib];
    _view4.delegate = self;
    [_view4 setFrame:CGRectMake(DEVICE_WIDTH*3, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    [_scrollView addSubview:_view1];
    [_scrollView addSubview:_view2];
    [_scrollView addSubview:_view3];
    [_scrollView addSubview:_view4];
}

- (void)setupPlayer
{
    _bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingString:@"/onesecond.mp4"];
    
    // 1.初始化PlayerItem
    AVPlayerItem *playerItem = [OSGuidingViewModel getPlayItemWithVideoUrlString:_bundlePath];
    // 2.初始化Player
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    // 3. 初始化AVPlayerLayer 显示视频
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    [_playerLayer setFrame:CGRectMake(- 0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.backGroundView.layer addSublayer:_playerLayer];

    //给AVPlayerItem添加播放完成通知
    [self addNotification];
    
    // 添加程序进入后台暂停
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationWillResignActiveNotification:)
//                                                 name:UIApplicationWillResignActiveNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [self.player play];
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

-(void)addNotification
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark ------------------ 代理事件 -----------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x/DEVICE_WIDTH;
    [_pageControl setCurrentPage:current];
    
    // 显现动画
    switch (current) {
        case 0:
        {
            break;
        }
        case 1:
        {
            [_view2 startAnimation];
            break;
        }
        case 2:
        {
            [_view3 startAnimation];
            break;
        }
        case 3:
        {
            [_view4 startAnimation];
            break;
        }
        default:
            break;
    }
}

- (void)gotoMainViewController
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"FirstLoad"];
    
    OSRecordingViewController *vc = [[OSRecordingViewController alloc] init];
    OSNavigationController *nav = [[OSNavigationController alloc] initWithRootViewController:vc];
    OSSideMenuController *sideMenuController = [[OSSideMenuController alloc] initWithRootViewController:nav];
    [sideMenuController setRightViewSwipeGestureEnabled:NO];
    vc.delegate = (id)sideMenuController.leftSideViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = sideMenuController;
}

#pragma mark ------------------ 通知事件 -----------------------
- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    if(self.player.rate == 0){ //说明时暂停
        [self.player play];
    }else {
        [self.player play];
    }
}

- (void)applicationWillResignActiveNotification:(NSNotification *)notification
{
    if(self.player.rate == 1){//正在播放
        [self.player pause];
    }else {
        [self.player pause];
    }
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    if(self.player.rate == 1){//正在播放
        [self.player pause];
    }else {
        [self.player pause];
    }
}

#pragma mark ------------------ 退出清空 -----------------------

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
