//
//  OSReplayViewModel.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/14.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSReplayViewModel.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "OSFileUtil.h"
#import "OSDateUtil.h"

@interface OSReplayViewModel()

@property (nonatomic, strong) AVAsset *videoAsset;

@end

@implementation OSReplayViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -------------------- 功能函数 ---------------------

- (void)startAddWatermarkToVideoWithURL:(NSURL *)videoUrl dateModel:(OSDateModel *)dateModel successBlock:(AddWatermarkToVideoBlock)success
{
    // 1.准备视频资源
    self.videoAsset = [AVAsset assetWithURL:videoUrl];
    
    if (!self.videoAsset) {
        // 为空弹框提醒错误
        return;
    }
    // 2 - 创建AVMutableComposition 对象 这个对象将持有AVMutableCompositionTrack实例.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 音频
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:kCMTimeZero
                          error:nil];

    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);

    // 添加你想要加的水印内容
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize dateModel:dateModel];

    // 4 - Get path
    NSURL *url = [OSFileUtil getFilePathURLWithDocument:[NSString stringWithFormat:@"%@.mp4",dateModel.date]];;
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
//    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter block:success];
        });
    }];
}

#pragma mark ---------------- 功能函数 ------------------------

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size dateModel:(OSDateModel *)dateModel
{
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    
    [subtitle1Text setFrame:CGRectMake(12, 0, size.width, 25)];
    

    [subtitle1Text setForegroundColor:[[OSColor pureWhiteColor] CGColor]];
    [subtitle1Text setAlignmentMode:kCAAlignmentLeft];
    [subtitle1Text setWrapped:YES];
    
    UIFont *font = [OSFont nextDayFontWithSize:ExplanatoryFontSize];
    
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [subtitle1Text setFont:fontRef]; // @"Helvetica-Bold"
    [subtitle1Text setFontSize:ExplanatoryFontSize];
    CGFontRelease(fontRef);
    
    [subtitle1Text setString:[OSDateUtil getWatemarkDateWithDate:dateModel.date]];
    
//    [subtitle1Text setContentsScale:2];
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    [overlayLayer addSublayer:subtitle1Text];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

- (void)exportDidFinish:(AVAssetExportSession*)session block:(AddWatermarkToVideoBlock)success
{
    if (session.status == AVAssetExportSessionStatusCompleted) {
        success(YES);
    }else {
        success(NO);
    }
}

@end
