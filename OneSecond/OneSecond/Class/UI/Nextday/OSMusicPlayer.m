//
//  OSMusicPlayer.m
//  OneSecond
//
//  Created by JHR on 15/12/2.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSMusicPlayer.h"

@interface OSMusicPlayer()

@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) BOOL isStartTimer;  // 定时器标志位
@property (nonatomic, assign) BOOL isStartPlay;   // 是否开始播放

@end

@implementation OSMusicPlayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        // 配置音乐config
        _playItem = [[FSPlaylistItem alloc] init];
        _configuration = [[FSStreamConfiguration alloc] init];
        _configuration.usePrebufferSizeCalculationInSeconds = YES; // 默认
//        _configuration.usePrebufferSizeCalculationInSeconds = NO;
//        _configuration.requiredInitialPrebufferedByteCountForContinuousStream = 100000;
//        _configuration.requiredInitialPrebufferedByteCountForNonContinuousStream = 100000;

        _configuration.cacheEnabled = NO;
        
        _audioController = [[FSAudioController alloc] init];
        _audioController.delegate = self;
        [_audioController setVolume:.9f];
        _audioController.enableDebugOutput = NO;
        
        // 初始化 ---------
        _paused = YES;
        _isStartTimer = NO;
        _isStartPlay = NO;
        
        self.audioController.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
            NSString *errorCategory;
            
            switch (error) {
                case kFsAudioStreamErrorOpen:
                    errorCategory = @"Cannot open the audio stream: ";
                    break;
                case kFsAudioStreamErrorStreamParse:
                    errorCategory = @"Cannot read the audio stream: ";
                    break;
                case kFsAudioStreamErrorNetwork:
                    errorCategory = @"Network failed: cannot play the audio stream: ";
                    break;
                case kFsAudioStreamErrorUnsupportedFormat:
                    errorCategory = @"Unsupported format: ";
                    break;
                case kFsAudioStreamErrorStreamBouncing:
                    errorCategory = @"Network failed: cannot get enough data to play: ";
                    break;
                default:
                    errorCategory = @"Unknown error occurred: ";
                    break;
            }
        };
        
        self.audioController.onMetaDataAvailable = ^(NSDictionary *metaData) {
            
        };
    }
    return self;
}

- (void)play:(UIButton *)button andProgressView:(UIProgressView *)progressView
{
    if (!_isStartTimer) {
        
        _isStartTimer = YES;
        self.audioController.configuration = _configuration;
        
        if (self.playItem.url) {
            self.audioController.url = self.playItem.url;
        }else if (self.playItem.originatingUrl) {
            self.audioController.url = self.playItem.originatingUrl;
        }
        
        _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                                target:self
                                                              selector:@selector(updatePlaybackProgress)
                                                              userInfo:nil
                                                              repeats:YES];
    }
    
    if (_paused == YES && _isStartPlay) {
        _paused = NO;
        [self.audioController pause];
        [button setImage:[UIImage imageNamed:@"pause_music"] forState:UIControlStateNormal];
        
    }else if (_paused == NO && _isStartPlay){
        _paused = YES;
        [self.audioController pause];
        [button setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];

    }else {
        _isStartPlay = YES;
        _paused = NO;
        [self.audioController playFromURL:_playItem.url];
        [button setImage:[UIImage imageNamed:@"pause_music"] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:button];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForegroundNotification:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        _audioController.onStateChange =  ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamRetrievingURL:
                    break;
                case kFsAudioStreamStopped:
                {
                
                    break;
                }
                case kFsAudioStreamBuffering:
                    break;
                case kFsAudioStreamSeeking:
                    break;
                case kFsAudioStreamPlaying:
                    break;
                case kFsAudioStreamFailed:
                    break;
                case kFsAudioStreamPlaybackCompleted:
                {
                    // 初始化
                    _isStartPlay = NO;
                    _paused = NO;
//                    progressView.progress = 0.0f;
                    [progressView setProgress:0.0f];
                    [button setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];
                    break;
                }
                case kFsAudioStreamRetryingStarted:
                    break;
                case kFsAudioStreamRetryingSucceeded:
                {
                    
                    break;
                }
                case kFsAudioStreamRetryingFailed:
                    break;
                default:
                    break;
            }
        };
    }
}

- (void)updatePlaybackProgress
{
 
    
    if (self.audioController.activeStream.contentLength > 0) {
        // A non-continuous stream, show the buffering progress within the whole file
        FSSeekByteOffset currentOffset = self.audioController.activeStream.currentSeekByteOffset;
        
//        UInt64 totalBufferedData = currentOffset.start + self.audioController.activeStream.prebufferedByteCount;
        
//        float bufferedDataFromTotal = (float)totalBufferedData / self.audioController.activeStream.contentLength;
        
//        self.playerProgressView.progress = (float)currentOffset.start / self.audioController.activeStream.contentLength;
        [self.playerProgressView setProgress:(float)currentOffset.start /self.audioController.activeStream.contentLength animated:YES];
    }
}

#pragma mark --------- 通知事件 -----------------------
- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
//    _analyzer.enabled = NO;
//    
//    [_stateLogger logMessageWithTimestamp:@"Application entering background"];
//    
//    if (!self.paused && self.isStartPlay) {
//        // Don't leave paused continuous stream on background;
//        // Stream will eventually fail and restart
//        self.isStartPlay = NO;
//        [self.audioController stop];
//    
//        [(UIButton *)notification.object setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];
//    }
}
//
- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
//    _analyzer.enabled = _analyzerEnabled;
//    
//    [_stateLogger logMessageWithTimestamp:@"Application entering foreground"];
}

#pragma mark -------- delegate ------------------------
- (BOOL)audioController:(FSAudioController *)audioController allowPreloadingForStream:(FSAudioStream *)stream
{
    // We could do some fine-grained control here depending on the connectivity status, for example.
    // Allow all preloads for now.
    return YES;
}

- (void)audioController:(FSAudioController *)audioController preloadStartedForStream:(FSAudioStream *)stream
{
    // Should we display the preloading status somehow?
}

#pragma mark ------ 退出清空 ---------------------------

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)playerWillAppear
{
    if (!self.audioController.activeStream.continuous && self.audioController.isPlaying) {
        // If a file with a duration is playing, store its last known playback position
        // so that we can resume from the same position, if the same file
        // is played again
        
//        _lastSeekByteOffset = self.audioController.activeStream.currentSeekByteOffset;
//        _lastPlaybackURL = [self.audioController.url copy];
    } else {
//        _lastPlaybackURL = nil;
        
    }
}

- (void)playerDidDisappear
{
    // Free the resources (audio queue, etc.)
    _audioController = nil;
    
    // 停止定时器
    if (_progressUpdateTimer) {
        [_progressUpdateTimer invalidate], _progressUpdateTimer = nil;
    }
}

@end
