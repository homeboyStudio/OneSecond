//
//  OSMovieClipViewModel.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSMovieClipViewModel.h"
#import "DBDateUtils.h"

@interface OSMovieClipViewModel()

@property (nonatomic, strong) NSMutableArray *fileURLArray;

@end

@implementation OSMovieClipViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileURLArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startClipProgressWithBlock:(ProgressSuccessBlock)success
{
    // 子线程开始执行任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *dateModelArray = [DBDateUtils getAllDateModelFromDateBase];
        for (OSDateModel *model in dateModelArray) {
            NSURL *fileUrl = [OSFileUtil getFilePathURLWithDocument:model.video_url];
            [_fileURLArray addObject:fileUrl];
        }
        [self mergeAndExportVideosAtFileURLs:_fileURLArray block:success];
    });
}

#pragma mark -------- 功能函数 --------------

- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray block:(ProgressSuccessBlock)success
{
    NSError *error = nil;
    CGSize renderSize = CGSizeMake(0, 0);  // 渲染尺寸
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];           // Array1
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

    CMTime totalDuration = kCMTimeZero;     // 整体持续时间
    
    //先去assetTrack 也为了取renderSize
//    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];                // Array2
//    NSMutableArray *assetArray = [[NSMutableArray alloc] init];                     // Array3


    NSArray *array =  [NSArray arrayWithObjects:fileURLArray[0],fileURLArray[1],fileURLArray[2],fileURLArray[3],fileURLArray[4],fileURLArray[5],fileURLArray[6],fileURLArray[7],fileURLArray[8],fileURLArray[9],fileURLArray[10],fileURLArray[11],fileURLArray[12],fileURLArray[13],fileURLArray[14],fileURLArray[14],nil];
    
    for (NSURL *url in array) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        if (!asset) {
            continue;
        }
//        [assetArray addObject:asset];                   // Array3将资源媒体对象添加到数组当中
        
        // 一个AVAssetTrack对象提供了所有资产提供track-level检查接口
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//        [assetTrackArray addObject:assetTrack];

        // 渲染尺寸 假如视频尺寸为480：640 =  3：4  这里取出的总是最大的视频尺寸
        // 480         0                       480
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.width);
        // 640         0                       640
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.height);
//    }
    
    // 取两者最小值   480
//    CGFloat renderW = MIN(renderSize.width, renderSize.height);

//    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {     // Array2,3
    
        // 取出AVAsset
//        AVAsset *asset = [assetArray objectAtIndex:i];                                // Array3
        // 取出AVAssetTrack
//        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];                 // Array2
        
        
        // 音频
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
        // 视频
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        
        
        //fix orientation issue  修复方向问题
        // AVMutableVideoCompositionLayerInstruction是一个可变的子类AVVideoCompositionLayerInstruction用于修改变换,裁剪,不透明度坡道适用于一个给定的轨道组成。
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
//        CGFloat rate;   // 比例              640                              480
//        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * 1, assetTrack.preferredTransform.ty * 1);
        
//        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
//
//        layerTransform = CGAffineTransformScale(layerTransform, 1, 1);//放缩，解决前后摄像结果大小不对称
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        //data
        [layerInstructionArray addObject:layerInstruciton];     // Array1
    }

    //get save path
    NSURL *mergeFileURL = [OSFileUtil getFilePathURLWithDocument:@"clip.mp4"];
    NSString *mergeFileString = [OSFileUtil getFilePathStringWithDocument:@"clip.mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:mergeFileString]) {
        [[NSFileManager defaultManager] removeItemAtPath:mergeFileString error:nil];
    }

    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;                   // Array1
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = renderSize;
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = mainCompositionInst;
    
//    NSString *documentsDirPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSURL *documentsDirUrl = [NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
//    NSURL *url = [NSURL URLWithString:@"clip.mp4" relativeToURL:documentsDirUrl];
    
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    
//    DLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    // 表示该视频是否应该对网络使用进行优化
//    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
         NSError *error = exporter.error;
        switch (exporter.status) {
            case AVAssetExportSessionStatusFailed:
            {
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    success(YES, error, mergeFileString);
                });
                break;
            }
            default:
                break;
        }
    }];
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

@end
