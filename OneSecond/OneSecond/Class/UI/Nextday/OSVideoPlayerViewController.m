//
//  OSVideoPlayerViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/8.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSVideoPlayerViewController.h"
#import "OSSideMenuController.h"

@interface OSVideoPlayerViewController ()

@property (nonatomic, strong) AVPlayer *player;                           // 播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer;                 // 显示窗口
@property (nonatomic, copy) NSString *bundlePath;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) BOOL isShowPlaying;     // 是否正在展示动画页面

@end

@implementation OSVideoPlayerViewController

#pragma mark ------------- 初始化 --------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isShowPlaying = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingString:@"/oneday.mp4"];
    
    // 1.初始化PlayerItem
    AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:_bundlePath];
    // 2.初始化Player
    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    // 3. 初始化AVPlayerLayer 显示视频
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    CGFloat offset = 50.0f;
    CGFloat lineSpacing = 30.0f;
    CGFloat height = 400;
    if ([OSDevice isDeviceIPhone4s]) {
        offset = 40.0f;
        lineSpacing = 20.0;
        height = 360;
    }else if ([OSDevice isDeviceIPhone5]) {
        offset = 40.0;
        lineSpacing = 25.0f;
    }else if ([OSDevice isDeviceIPhone6Plus]) {
        offset = 55.0f;
        lineSpacing = 30.0f;
    }
    
    [_playerLayer setFrame:CGRectMake(- offset, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_playerLayer];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(40, (DEVICE_HEIGHT - height)/2, 110, height)];
    [_textView setAttributedText:[self getAttributedString:@"T  H  E             N  E  X  T        D  A  Y              I  S                   A  L  W  A  Y  S  A                         N  E  W                D  A  Y" lineSpacing:lineSpacing]];
    [_textView setTextAlignment:NSTextAlignmentLeft];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setUserInteractionEnabled:NO];
    [self.view addSubview:_textView];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightViewWillShow) name:kLGSideMenuControllerWillShowRightViewNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightViewDidDismiss) name:kLGSideMenuControllerDidDismissRightViewNotification object:nil];
    
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

    //给AVPlayerItem添加播放完成通知
    [self addNotification];
}

#pragma mark ------------- 通知事件 -------------------
- (void)rightViewWillShow
{
    _isShowPlaying = YES;
    // 播放
    [self.player play];
    
    [_textView setAlpha:0.0f];
    [UIView animateWithDuration:7.0f animations:^{
        [_textView setAlpha:1.0f];
    }];
}

- (void)rightViewDidDismiss
{
    _isShowPlaying = NO;
    // 停止
    [self.player pause];
    [self removeNotification];
    AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:_bundlePath];
    [playerItem seekToTime:kCMTimeZero];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addNotification];
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

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    if (_isShowPlaying) {
        [self.player play];
    }
}

- (void)applicationWillResignActiveNotification:(NSNotification *)notification
{
    if (_isShowPlaying) {
        [self.player pause];
    }
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    if (_isShowPlaying) {
        [self.player pause];
    }
}

#pragma mark ------------- 功能函数 -------------------
/**
 *  根据视频地址取得AVPlayerItem对象
 *
 *  @param videoUrl 视频地址
 *
 *  @return AVPlayerItem对象
 */
- (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl
{
    NSURL *url = [NSURL fileURLWithPath:[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    return playItem;
}

#pragma mark - --------------------功能函数--------------------
#pragma mark 初始化
- (NSAttributedString *)getAttributedString:(NSString *)string lineSpacing:(CGFloat)spacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spacing;  // 字体间距
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [OSFont nextDayFontWithSize:ExplanatoryFontSize], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName: [OSColor pureWhiteColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

#pragma mark ------------- 退出清空 -------------------
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
