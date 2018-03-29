//
//  OSPlayerView.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/9.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSPlayerView.h"

@interface OSPlayerView()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *playButton;    // 播放按钮
@property (nonatomic, strong) UILabel  *dateLabel;     //
@property (nonatomic, strong) OSDateModel *dateModel;

@property (nonatomic, assign) BOOL isPlaying;  // 是否正在播放
@end

@implementation OSPlayerView

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
//    [self setupUI];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.playButton setAlpha:1.0f];
    [self removeNotification];
}

- (void)setup:(CGRect)frame
{
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 0.33;
//    self.layer.shadowOffset = CGSizeMake(0, 1.5);
//    self.layer.shadowRadius = 4.0;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
    
//    AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:[OSFileUtil getFilePathStringWithDocument:self.dateModel.video_url]];
    // 2.初始化Player
//    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.player = [[AVPlayer alloc] init];
    
    // 3. 初始化AVPlayerLayer 显示视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [playerLayer setFrame:frame];
    [playerLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.layer addSublayer:playerLayer];

    _playButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width - 55)/2, (frame.size.height - 55)/2, 55, 55)];
    [_playButton setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playVideoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
    
//    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 30)];
//    [_dateLabel setTextAlignment:NSTextAlignmentCenter];
//    [_dateLabel setTextColor:[OSColor pureWhiteColor]];
//    [_dateLabel setFont:[OSFont customFontWithSize:ExplanatoryFontSize]];
//    [self addSubview:_dateLabel];
    _isPlaying = NO;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setupUI
{
    // 1.初始化PlayerItem
    AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:[OSFileUtil getFilePathStringWithDocument:self.dateModel.video_url]];
    // 2.初始化Player
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    self.player = [[AVPlayer alloc] init];

    // 3. 初始化AVPlayerLayer 显示视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [playerLayer setFrame:self.frame];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.layer addSublayer:playerLayer];
    // KVO
//    [self addobserverToPlayerItem:playerItem];
    // 手势事件
    _isPlaying = NO;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction)];
    [self addGestureRecognizer:tapGestureRecognizer];

}

- (void)tapImageViewAction
{
    if(self.player.rate == 1){//正在播放
        [self.player pause];
        [UIView animateWithDuration:0.4 animations:^{
            [self.playButton setAlpha:1.0];
        }];
    }
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    AVPlayerItem *playerItem = object;
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
//        if (status == AVPlayerStatusReadyToPlay) {
//            DLog(@"视频长度为%.2f",CMTimeGetSeconds(playerItem.duration));
//        }
//    }
//}

- (void)updatePlayerWith:(OSDateModel *)model
{
    _isPlaying = NO;
    [self removeNotification];
    [self.player replaceCurrentItemWithPlayerItem:[self getPlayItemWithVideoUrlString:[OSFileUtil getFilePathStringWithDocument:model.video_url]]];
     [self addNotification];
//    [_dateLabel setText:model.date];
    _dateModel = model;
}

#pragma mark ---------- 按钮事件 -----------------
- (void)playVideoButtonAction
{
    if (_isPlaying) {
        if (self.player.rate == 0) {
            [self.player play];
            [UIView animateWithDuration:0.3 animations:^{
                [self.playButton setAlpha:0.0];
            }];
        }
    }else {
        _isPlaying = YES;
        // 先移除通知
        [self removeNotification];
        //    _player = [AVPlayer playerWithPlayerItem:playerItem];
        //    [self.player setRate:0.0f];
        AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:[OSFileUtil getFilePathStringWithDocument:self.dateModel.video_url]];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        [self addNotification];
        [self.player play];
    
        [UIView animateWithDuration:0.3 animations:^{
            [self.playButton setAlpha:0.0];
        }];
    }
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

#pragma mark ---------- 功能函数 -----------------
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

- (void)playbackFinished:(NSNotification *)notification
{
    _isPlaying = NO;
    [UIView animateWithDuration:0.4 animations:^{
        [self.playButton setAlpha:1.0];
    }];
}

// KVO
// 添加AVPlayerItem监控
//- (void)addobserverToPlayerItem:(AVPlayerItem *)playerItem
//{
//    // 监听状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem removeObserver:self forKeyPath:@"status"];
}

//- (void)removeFromSuperview
//{
//    [self removeObserverFromPlayerItem:self.player.currentItem];
//}

#pragma mark ----------- 退出清空 -----------------
- (void)dealloc
{
    [self removeNotification];
}

@end
