//
//  OSRecordingViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSRecordingViewController.h"
#import "OSSideMenuController.h"
#import <AVFoundation/AVFoundation.h>
#import "OSDateUtil.h"
#import "OSRecordingButton.h"

//#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface OSRecordingViewController ()<AVCaptureFileOutputRecordingDelegate, CAAnimationDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;  // 负责输入和输出设备间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput; // 负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureDeviceInput; // 音频输入数据

@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput; // 视频输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer; // 相机拍摄预览图

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识


@property (nonatomic, weak) IBOutlet UIButton *cameraChangeButton;  // 前置摄像头

@property (nonatomic, weak) IBOutlet UIView *tapGestureView;        // 设置聚光标相应区域
@property (nonatomic, weak) IBOutlet UIImageView *focusCursor;      // 聚焦光标

@property (nonatomic, weak) IBOutlet UIView *toolBackgroundView;    // 用来呈现控件
@property (nonatomic, weak) IBOutlet UIButton *homeButton;

@property (nonatomic, strong) NSString *video_url;   // 用来存储视频地址
@property (nonatomic, strong) NSString *date;        // 录制视频时间
@property (nonatomic, strong) OSRecordingButton *rcdButton;

@property (nonatomic, assign) double recordTime;  // 录制时间
@end

@implementation OSRecordingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width = 80.0f;
    CGFloat homeButtonWidth = 44.0;
    
    if ([OSDevice isDeviceIPhone4s]) {
        width = 52.0f;
        homeButtonWidth = 30.0f;
    }
    
    // 配置UI
    [self.tapGestureView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH*4)/3 - 20)];
    
    [self.toolBackgroundView setFrame:CGRectMake(0, (DEVICE_WIDTH*4)/3, DEVICE_WIDTH, (DEVICE_HEIGHT - (DEVICE_WIDTH*4)/3))];
    
    
    [_cameraChangeButton setFrame:CGRectMake(DEVICE_WIDTH - 44 - 20, 20, 44, 44)];
    
    [_homeButton setFrame:CGRectMake(30, (DEVICE_HEIGHT - (DEVICE_WIDTH*4)/3 - homeButtonWidth)/2, homeButtonWidth, homeButtonWidth)];
    [_homeButton addTarget:self action:@selector(openLeftSide) forControlEvents:UIControlEventTouchUpInside];
    
    _rcdButton = [[OSRecordingButton alloc] initWithFrame:CGRectMake((DEVICE_WIDTH - width)/2,(DEVICE_HEIGHT - (DEVICE_WIDTH*4)/3 - width)/2 , width, width) type:kRMClosedIndicator target:self sel:@selector(recordingButtonAction)];
    
    [self.toolBackgroundView addSubview:_rcdButton];
    
    // 添加手势
    [self addGenstureRecognizer];
//    [self setCustomTitle:@"一秒"];
//    [self setLeftBarButtonWithTitle:@"弹出" target:self action:@selector(openLeftSide)];
//    [self.osNavigationController setNavigationBarBackgroundAlpha:0.0f];
    
    // 读取时间
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    double time = [userDefault doubleForKey:@"recordtime"];
    if (time) {
        _recordTime = time;
    }else {
        _recordTime = 1.0;
    }
    
    [self.osNavigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    // 设置分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    // 获得输入设备
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        // 错误处理
        return;
    }
    
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    if (!audioCaptureDevice) {
        // 错误处理
        return;
    }
    
    NSError *error = nil;
    // 根据输入设备初始化设备输入对象，用于获得输入数据
    _videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        DLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    _audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        DLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_videoCaptureDeviceInput]) {
        [_captureSession addInput:_videoCaptureDeviceInput];
        [_captureSession addInput:_audioCaptureDeviceInput];
        
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    // 创建视频预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    CALayer *layer = self.view.layer;
    layer.masksToBounds = YES;
    _captureVideoPreviewLayer.frame = CGRectMake(0, 0, DEVICE_WIDTH, (DEVICE_WIDTH*4)/3);   // 3:4
    _captureVideoPreviewLayer.backgroundColor = [UIColor clearColor].CGColor;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect; //填充模式
    
    //将视频预览层添加到界面中
//    [layer addSublayer:_captureVideoPreviewLayer];
    [layer insertSublayer:_captureVideoPreviewLayer below:_cameraChangeButton.layer];
    
    // 添加通知监听
    [self addNotificationToCaptureDevice:captureDevice];
    [self addNotificationToCaptureSession:self.captureSession];
   
    [self.captureSession startRunning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

#pragma mark ------- 通知事件 ---------------

/**
 *  给输入设备添加通知
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice
{
    // 注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconnected:) name:AVCaptureDeviceWasDisconnectedNotification object:captureDevice];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceConnected:) name:AVCaptureDeviceWasConnectedNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  移除所有通知
 */
- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    DLog(@"设备已连接...");
}

/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    DLog(@"设备已断开.");
}

/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
//    DLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification
{
    DLog(@"会话发生错误.");
}

#pragma mark ------- 手势 ------------------
- (void)addGenstureRecognizer
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.tapGestureView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.view];
    // 将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    // 设置聚光标位置
    [self setFocusCursorWithPoint:point];
    // 设置摄像头聚焦点
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.tapGestureView.userInteractionEnabled = NO;
    self.focusCursor.center = point;
    self.focusCursor.alpha = 1.0;
    // 动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.35, 1.35, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];

    animation.values = values;
    animation.delegate = self;
    [self.focusCursor.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursor.alpha = 0;
    }];
    self.tapGestureView.userInteractionEnabled = YES;
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

#pragma mark ------- 按钮事件 ---------------
- (void)openLeftSide
{
    OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [menuController showLeftViewAnimated:YES completionHandler:^{
        
    }];
}

- (IBAction)cameraChangeButtonAction:(UIButton *)sender
{
//    OSReplayViewController *replayViewController = [[OSReplayViewController alloc] init];
//    replayViewController.dateModel.date = self.date;
//    replayViewController.dateModel.video_url = self.video_url;
//    [self.osNavigationController pushViewController:replayViewController animated:YES];
//    return;
    
    AVCaptureDevice *captureDevice = [self.videoCaptureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [captureDevice position];
    // 移除通知
    [self removeNotificationFromCaptureDevice:captureDevice];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    // 获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    // 改变会话的配置前一定要先开启配置，配置完后提交配置
    [self.captureSession beginConfiguration];
    // 移除原有对象
    [self.captureSession removeInput:self.videoCaptureDeviceInput];
    // 添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.videoCaptureDeviceInput = toChangeDeviceInput;
    }
    // 提交会话配置
    [self.captureSession commitConfiguration];
}

- (void)recordingButtonAction
{
    // 检查设备授权状态
    if (![self checkDeviceAuthorizedStated]) {
        return;
    }
    // 录制按钮，加一个定时器录制一秒钟视频
    // 根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (![self.captureMovieFileOutput isRecording]) {
        
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        // 预览图层和视频方向保持一致
        captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
        
        NSString *dateString = [OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6];
        
        // 保存录制时间，和视频存放地址
        self.date = dateString;
        self.video_url = @"temp.mp4";
        
        double delayInSeconds = _recordTime;
        
        // 动画
        [_rcdButton loadIndicator];
        [_rcdButton setIndicatorAnimationDuration:delayInSeconds];
        [_rcdButton updateWithTotalBytes:100 downloadedBytes:100];
        [self setControlStatus:NO];
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        [self.captureMovieFileOutput startRecordingToOutputFileURL:[OSFileUtil getFilePathURLWithDocument:@"temp.mp4"] recordingDelegate:self];
        dispatch_after(stopTime, dispatch_get_main_queue(), ^{
            //停止录制
            [self.captureMovieFileOutput stopRecording];
            [self setControlStatus:YES];
        });
    }
}

- (BOOL)checkDeviceAuthorizedStated
{
    BOOL success = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //无权限
        success = NO;
        [[[UIAlertView alloc] initWithTitle:@"无法录制" message:@"您未允许应用访问\"相机\"权限，请到系统设置-隐私-相机-允许一秒访问，来继续录制视频操作。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return success;
    }else {
        __block BOOL bCanRecord = YES;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
        {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                    bCanRecord = granted;
                }];
            }
        }
        if (!bCanRecord) {
             [[[UIAlertView alloc] initWithTitle:@"无法录制" message:@"您未允许应用访问\"麦克风\"权限，请到系统设置-隐私-麦克风-允许一秒访问，来继续录制视频操作。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        return bCanRecord;
    }
}

#pragma mark ------- 代理事件 ---------------
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    //    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    DLog(@"视频录制完成,outputUrl:%@",outputFileURL);
    
    OSReplayViewController *replayViewController = [[OSReplayViewController alloc] init];
    replayViewController.delegate = self.delegate;
    replayViewController.dateModel.date = self.date;
    replayViewController.dateModel.video_url = self.video_url;
    [self.osNavigationController pushViewController:replayViewController animated:YES];
    [_rcdButton loadIndicator];
}

#pragma mark ------- 功能函数 ---------------

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice = [self.videoCaptureDeviceInput device];
    NSError *error;
    
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else {
      // 错误处理
        DLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)setControlStatus:(BOOL)isTrue
{
    [_rcdButton setUserInteractionEnabled:isTrue];
    [_cameraChangeButton setUserInteractionEnabled:isTrue];
    [_homeButton setUserInteractionEnabled:isTrue];
}

#pragma mark ------- 退出清空 ---------------

- (void)dealloc
{
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
