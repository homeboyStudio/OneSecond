//
//  OSReplayViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSReplayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Check.h"
#import "MBProgressHUD.h"
#import "UIImage+OSColor.h"
#import "UIImage+OSCompress.h"
#import "AMTumblrHud.h"
#import "DBDateUtils.h"
#import "OSSideMenuController.h"
#import "OSReplayViewModel.h"

@interface OSReplayViewController ()

@property (nonatomic, strong) AVPlayer *player;  // 播放器对象

@property (nonatomic, weak) IBOutlet UIImageView *playBackgroundImageView;

@property (nonatomic, weak) IBOutlet UIButton *playButton;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;   // 保存按钮
@property (nonatomic, weak) IBOutlet UIButton *cancelButton; // 取消按钮

@property (nonatomic, weak) IBOutlet UILabel *saveLabel;     // 存储Label
@property (nonatomic, weak) IBOutlet UILabel *cancelLabel;   // 取消Label

@property (nonatomic, weak) IBOutlet UILabel *countLabel;    // 录制总数Label

@property (nonatomic, strong)  AVPlayerLayer *avplayerLayer;

@property (nonatomic, weak) OSSideMenuController *menuController;

@property (nonatomic, strong) OSReplayViewModel *replayViewModel;   // ViewModel
@property (nonatomic, assign) BOOL isPlaying;  // 正在播放

@end

@implementation OSReplayViewController

#pragma mark - --------------------System--------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dateModel = [[OSDateModel alloc] init];
        self.replayViewModel = [[OSReplayViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
    _menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    // 是否进入就播放播放视频
    // [self.player play];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_menuController setLeftViewSwipeGestureEnabled:NO];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.osNavigationController setNavigationBarHidden:YES animated:YES];  // 隐藏导航栏
//    [self.osNavigationController setNavigationBarBackgroundAlpha:0.0f];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_menuController setLeftViewSwipeGestureEnabled:YES];

    [self.osNavigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - --------------------功能函数--------------------
#pragma mark 初始化

- (void)setupUI
{
    // 初始化UI
    [self.playBackgroundImageView.layer setMasksToBounds:YES];
    
    
    CGFloat DeviceWidth = DEVICE_WIDTH;
    CGFloat PlayHeight = (DEVICE_WIDTH*4)/3;
    // 设置Frame
    [self.playBackgroundImageView setFrame:CGRectMake(0, 0, DeviceWidth, PlayHeight)];
    
    [self.playButton setFrame:CGRectMake((DeviceWidth - 60)/2, (PlayHeight - 60)/2, 60, 60)];
    
    [self setupButtonAndBackgroundImage:DeviceWidth PlayHeight:PlayHeight];
    
// -------------------------------------------------------------------------
//    [self setCustomTitle:@"第 1 个一秒"];
    if ([NSString emptyOrNull:self.dateModel.video_url]) {
        // 获取视频地址失败！！
        return;
    }
    // 1.初始化PlayerItem
    AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:[OSFileUtil getFilePathStringWithDocument:self.dateModel.video_url]];
    // 2.初始化Player
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    // 3. 初始化AVPlayerLayer 显示视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [playerLayer setFrame:CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH*4)/3)];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    _avplayerLayer = playerLayer;
    [self.playBackgroundImageView.layer addSublayer:playerLayer];
    // 4.添加监听
    [self addProgessObserver];
    // KVO
    [self addobserverToPlayerItem:playerItem];
    
    // 手势事件
    // 触摸事件
    _isPlaying = NO;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction)];
    [self.playBackgroundImageView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark ------- 手势事件 ------------
- (void)tapImageViewAction
{
    if(self.player.rate == 1){//正在播放
        [self.player pause];
        [UIView animateWithDuration:0.4 animations:^{
            [self.playButton setAlpha:1.0];
        }];
    }
}

- (void)setupButtonAndBackgroundImage:(CGFloat)DeviceWidth PlayHeight:(CGFloat)PlayHeight
{
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 50;
    CGFloat offSet = 0;
    if ([OSDevice isDeviceIPhone4s]) {
        buttonWidth = 30;
        buttonHeight = 30;
        offSet = 7;
    }
    
    CGFloat buttonOffsetY = PlayHeight + (DEVICE_HEIGHT - PlayHeight - buttonHeight)/2;
    
    [self.cancelButton setFrame:CGRectMake(30, buttonOffsetY - offSet, buttonWidth, buttonHeight)];
    [self.cancelLabel setFrame:CGRectMake(30, buttonOffsetY + buttonHeight - offSet, buttonWidth, 20)];
    
    [self.saveButton setFrame:CGRectMake(DEVICE_WIDTH - 30 - buttonWidth, buttonOffsetY - offSet, buttonWidth, buttonHeight)];
    [self.saveLabel setFrame:CGRectMake(DEVICE_WIDTH - 30 - buttonWidth, buttonOffsetY + buttonHeight - offSet, buttonWidth, 20)];
    
//    [self.playButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    
//    [self.saveButton.layer setCornerRadius:buttonWidth/2];
//    [self.saveButton.layer setMasksToBounds:YES];
//    [self.saveButton setImage:[UIImage imageNamed:@"btn_success"] forState:UIControlStateNormal];
//    [self.saveButton setBackgroundImage:[UIImage imageFromColor:[OSColor skyBlueColor]] forState:UIControlStateNormal];
//    
//    [self.cancelButton.layer setCornerRadius:buttonWidth/2];
//    [self.cancelButton.layer setMasksToBounds:YES];
//    [self.cancelButton setImage:[UIImage imageNamed:@"btn_cancel"] forState:UIControlStateNormal];
//    [self.cancelButton setBackgroundImage:[UIImage imageFromColor:[OSColor specialorangColor]] forState:UIControlStateNormal];
    
    [self.saveLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    [self.saveLabel setTextColor:[OSColor skyBlueColor]];
    
    [self.cancelLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    [self.cancelLabel setTextColor:[OSColor specialorangColor]];
    
//    [self.countLabel setFont:[OSFont customFontWithSize:ExplanatoryFontSize]];
    
    NSUInteger count = [DBDateUtils countOfDateModelWithDateBase];
    if (![DBDateUtils existDateModelWithDataBase:_dateModel.date]) count += 1;
    NSString *countString = [NSString stringWithFormat:@"第 %lu 个一秒",(unsigned long)count];
    NSInteger length = [countString length];
    
    // ----------------- Label ---------------------------------
    CGFloat countWidth = [self widthForString:countString font:[OSFont nextDayFontWithSize:ExplanatoryFontSize] andHeight:0] + 15;
    [self.countLabel setFrame:CGRectMake((DeviceWidth - countWidth)/2, PlayHeight + 15, countWidth, 20)];
    
    // 707180
    [self.countLabel setBackgroundColor:[OSColor colorFromHex:@"#707180" alpha:0.1]];
    
    [self.countLabel.layer setCornerRadius:6];
    [self.countLabel.layer setMasksToBounds:YES];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:countString];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[OSColor skyBlueColor] range:NSMakeRange(0, 2)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[OSColor specialGaryColor] range:NSMakeRange(2, length - 6)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[OSColor skyBlueColor] range:NSMakeRange(length - 4, 4)];
    [attributeString addAttribute:NSFontAttributeName value:[OSFont nextDayFontWithSize:ExplanatoryFontSize] range:NSMakeRange(0, 2)];
    [attributeString addAttribute:NSFontAttributeName value:[OSFont nextDayFontWithSize:ExplanatoryFontSize] range:NSMakeRange(2, length - 6)];
    [attributeString addAttribute:NSFontAttributeName value:[OSFont nextDayFontWithSize:ExplanatoryFontSize] range:NSMakeRange(length - 4, 4)];
    [self.countLabel setAttributedText:attributeString];
}

// 播放器进度条
- (void)addProgessObserver
{
    //    AVPlayerItem *playerItem = [self.player currentItem];
    //   __block UIProgressView *progess = self.progessView;
    //    // 这里设置0.1秒执行一次
    //    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    //        float current = CMTimeGetSeconds(time);
    //        float total = CMTimeGetSeconds([playerItem duration]);
    //        if (current) {
    //            [progess setProgress:(current/total) animated:YES];
    //        }
    //    }];
}

// KVO
// 添加AVPlayerItem监控
- (void)addobserverToPlayerItem:(AVPlayerItem *)playerItem
{
    // 监听状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

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

- (NSString *)cutOutScreenShotWithVideo:(NSString *)videoUrl
{
    // 截取图片存入
    NSString *encodingString = [videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL fileURLWithPath:encodingString];
    
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;     // 修复截图方向错误
    /*截图
     * requestTime：缩略图创建时间
     * actualTime：缩略图实际生成的时间
     */
    NSError *error = nil;
    //CMTime是表示电影时间信息的结构体,截取视频第0.1sec的第一帧
    // // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CMTime time = CMTimeMakeWithSeconds(1, 1);
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        // 截取图片失败！！
        return @"";
    }
    
    CMTimeShow(actualTime);
    UIImage *screenShotImage = [UIImage imageWithCGImage:cgImage];
    screenShotImage = [UIImage imageCompressForSize:screenShotImage RateFloat:0.2];
    
    // 保存到本地
    // 1.Image转换为JPEG OR PNG
    // PNG 格式
    NSData *pngImageData = UIImagePNGRepresentation(screenShotImage);
    NSString *imageUrlString = [OSFileUtil getFilePathStringWithDocument:[NSString stringWithFormat:@"%@.png",self.dateModel.date]];
    [pngImageData writeToFile:imageUrlString atomically:YES];
    
    // JPG 格式
//    NSData *jpegImageData = UIImageJPEGRepresentation(screenShotImage, 1.0);
//    NSString *jpegUrlString = [documentString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",self.dateModel.date]];
//    [jpegImageData writeToFile:jpegUrlString atomically:YES];
    
    // 释放
    CGImageRelease(cgImage);
    // 返回名称
    return [NSString stringWithFormat:@"%@.png",self.dateModel.date];
}


- (float)widthForString:(NSString *)value font:(UIFont *)font andHeight:(CGFloat)height
{
    //    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:font}];
    CGSize sizeToFit = [value sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat width = sizeToFit.width;
    return width;
}

#pragma mark - --------------------手势事件--------------------
#pragma mark 各种手势处理函数注释

#pragma mark - --------------------按钮事件--------------------
#pragma mark 按钮点击函数注释

- (IBAction)playButtonAction:(UIButton *)sender
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
        [self removeObserverFromPlayerItem:self.player.currentItem];
        
        // 重新播放
        AVPlayerItem *playerItem = [self getPlayItemWithVideoUrlString:[OSFileUtil getFilePathStringWithDocument:self.dateModel.video_url]];
        
        [self addobserverToPlayerItem:playerItem];
        //    _player = [AVPlayer playerWithPlayerItem:playerItem];
        //    [self.player setRate:0.0f];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        
        [self addNotification];
        [self.player play];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.playButton setAlpha:0.0];
        }];
    }
}

- (IBAction)saveButtonAction:(UIButton *)sender
{
    if (self.player.rate == 1) {
        [self.player pause];
    }
    // 先停止播放视频，在写入数据库
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

    // 子线程操作，然后回调
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *realVideoString = [OSFileUtil getFilePathStringWithDocument:[NSString stringWithFormat:@"%@.mp4",self.dateModel.date]];
        BOOL isUpdateOperation = NO;
        // 先判断是否存在今日拍摄的视频，如果存在则删除(将要添加新的视频)
        if ([[NSFileManager defaultManager] fileExistsAtPath:realVideoString]) {
            isUpdateOperation = YES;
            [[NSFileManager defaultManager] removeItemAtPath:realVideoString error:nil];
        }
        
        [_replayViewModel startAddWatermarkToVideoWithURL:[OSFileUtil getFilePathURLWithDocument:self.dateModel.video_url] dateModel:self.dateModel successBlock:^(BOOL Success) {
            if (Success) {
                // 主线程
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.dateModel.video_url = [NSString stringWithFormat:@"%@.mp4",self.dateModel.date];
                    // 截取图片
                    self.dateModel.image_url = [self cutOutScreenShotWithVideo:realVideoString];
                    
                    // 如果存在今日拍摄的视频则说明是update操作
                    if (isUpdateOperation) {
                        [DBDateUtils updateDataModelWithDataBase:self.dateModel];
                    }else {
                        [DBDateUtils addDateModelToDataBase:self.dateModel];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(changeToCalendarViewController:)]) {
                            OSCalendarViewController *vc = [[OSCalendarViewController alloc] init];
                            [hud hide:YES];
                            [self.delegate changeToCalendarViewController:vc];
                        }else {
                            [hud hide:YES];
                            [self.osNavigationController popToRootViewControllerAnimated:YES];
                        }
                    });
                });
                
            }else {
                // 错误处理
                
            }
        }];
        
        // 将新拍摄的temp视频更改名称为
//        if ([[NSFileManager defaultManager] moveItemAtPath:[OSFileUtil getFilePathStringWithDocument:self.dateModel.video_url] toPath:realVideoString error:nil]) {
//            
//            self.dateModel.video_url = [NSString stringWithFormat:@"%@.mp4",self.dateModel.date];
//            
//            // 截取图片
//            self.dateModel.image_url = [self cutOutScreenShotWithVideo:realVideoString];
//            
//            // 如果存在今日拍摄的视频则说明是update操作
//            if (isUpdateOperation) {
//                [DBDateUtils updateDataModelWithDataBase:self.dateModel];
//            }else {
//                [DBDateUtils addDateModelToDataBase:self.dateModel];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hide:YES];
//                // 跳转到OScalendarViewController去
//                [self.osNavigationController popToRootViewControllerAnimated:YES];
//            });
//        }else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //        错误处理
//            });
//        }
    });
}

- (IBAction)cancelButtonAction:(UIButton *)sender
{
    [self.osNavigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------------代理方法--------------------
#pragma mark - 代理种类注释
#pragma mark 代理函数注释

#pragma mark - --------------------通知事件--------------------

- (void)playbackFinished:(NSNotification *)notification
{
    // 播放完毕显示播放按钮
    _isPlaying = NO;
    [UIView animateWithDuration:0.4 animations:^{
        [self.playButton setAlpha:1.0];
    }];
}

#pragma mark - --------------------属性相关--------------------
#pragma mark 属性操作函数注释

#pragma mark - --------------------接口API--------------------
#pragma mark 分块内接口函数注释

#pragma mark -------- 退出清空 ----------------

- (void)dealloc
{
    // 移除通知和KVO监听
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
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
