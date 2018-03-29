//
//  OSVideoClipViewModel.m
//  OneSecond
//
//  Created by JunhuaRao on 16/1/31.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import "OSVideoClipViewModel.h"
#import "DBDateUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCRecordSession.h"
#import "SCRecorder.h"
#import "SCRecordSession.h"
#import "SCAssetExportSession.h"

static NSString *movieName = @"clip.mp4";

@interface OSVideoClipViewModel()<SCAssetExportSessionDelegate>
{
    SCRecorder *_recorder;
}

@property (strong, nonatomic) SCAssetExportSession *exportSession;

@end

@implementation OSVideoClipViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)getPlayerItemsWithBlock:(getPlayerItemsBlock)success
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *itemsArray = [NSMutableArray array];
        float duration = 0;
        NSArray *dateModelArray = [DBDateUtils getAllDateModelFromDateBase];
        duration = dateModelArray.count;
        
//        for (int i = 0; i < 10; i ++) {
            for (OSDateModel *model in dateModelArray) {
                NSURL *fileUrl = [OSFileUtil getFilePathURLWithDocument:model.video_url];
                AVPlayerItem *item = [AVPlayerItem playerItemWithURL:fileUrl];
                [itemsArray addObject:item];
            }
//        }
        // main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            success(itemsArray, duration);
        });
    });
}

- (void)mergeVideo
{
    // 存储视频文件位置的file url
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSArray *dateModelArray = [DBDateUtils getAllDateModelFromDateBase];
    
    for (OSDateModel *model in dateModelArray) {
        NSURL *fileUrl = [OSFileUtil getFilePathURLWithDocument:model.video_url];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:fileUrl];
        [itemsArray addObject:item];
    }
    
    // 释放dateModelArray
    [self mergeAndExportVideosAtFileURLs:itemsArray];
}

- (void)mergeAndExportVideosAtFileURLs:(NSArray *)itemsArray
{
//    for (NSURL *url in itemsArray) {
//        AVAsset *asset = [AVAsset assetWithURL:url];
//    }
//    
//    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
//    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
//    
//    // 2 - Video track
//    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
//                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
//    
////    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
////                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
////    
////    
////    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
////                        ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
////    
////    // 3 - Audio track
////    if (audioAsset!=nil){
////        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
////                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
////        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
////                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
////    }
//    
//    // 4 - Get path
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
//    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
//    
//    
//    // 5 - Create exporter
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
//                                                                      presetName:AVAssetExportPresetHighestQuality];
//    exporter.outputURL=url;
//    exporter.outputFileType = AVFileTypeQuickTimeMovie;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self exportDidFinish:exporter];
//        });
//    }];
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
//        NSURL *outputURL = session.outputURL;
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
//            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (error) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
//                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    } else {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
//                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    }
//                });
//            }];
//        }
    }
//    audioAsset = nil;
//    firstAsset = nil;
//    secondAsset = nil;
//    [activityView stopAnimating];
}

#pragma maek ----------- 剪辑视频 ------------------

- (void)startMergeVideo
{
    
    // 可否在子线程
     _recorder = [SCRecorder recorder];
   
    NSDictionary *dictionary = [self getMetaDataDictionary];
    
    SCRecordSession *newRecordSession = [SCRecordSession recordSession:dictionary];
    
//    AVAssetWriter;
//    AVAssetWriterInput;
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:newRecordSession.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    
    // 存储位置
//    NSString *mergeFileString = [OSFileUtil getFilePathStringWithDocument:movieName];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:mergeFileString]) {
//        [[NSFileManager defaultManager] removeItemAtPath:mergeFileString error:nil];
//    }
    exportSession.outputUrl = [OSFileUtil getFilePathURLWithDocument:movieName];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    exportSession.contextType = SCContextTypeAuto;
    exportSession.contextType = SCContextTypeAuto;
    self.exportSession = exportSession;
    
//    CFTimeInterval time = CACurrentMediaTime();
    
    __weak typeof(self) wSelf = self;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        __strong typeof(self) strongSelf = wSelf;
        
        if (!exportSession.cancelled) {
            DLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        if (strongSelf != nil) {
            strongSelf.exportSession = nil;
//            [UIView animateWithDuration:0.3 animations:^{
//                strongSelf.exportView.alpha = 0;
//            }];
        }
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            DLog(@"Export was cancelled");
        } else if (error == nil) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            // 导入到相册当中
            [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];

                if (self.delegate && [self.delegate respondsToSelector:@selector(mergeResultWithError:)]) {
                    [self.delegate mergeResultWithError:error];
                }
            }];
        } else {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(mergeResultWithError:)]) {
                [self.delegate mergeResultWithError:error];
            }
        }
    }];
}

- (NSDictionary *)getMetaDataDictionary
{
    // SCRecordSessionSegmentsKey
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSArray *dateModelArray = [DBDateUtils getAllDateModelFromDateBase];
    for (OSDateModel *model in dateModelArray) {
//        NSURL *fileUrl = [OSFileUtil getFilePathURLWithDocument:model.video_url];   
        NSDictionary *dic = [NSDictionary dictionaryWithObject:model.video_url forKey:SCRecordSessionSegmentFilenameKey];
        [itemsArray addObject:dic];
    }

    // SCRecordSessionDurationKey:@""
    return @{SCRecordSessionSegmentsKey:itemsArray,SCRecordSessionIdentifierKey:@"N/A",SCRecordSessionDateKey:[NSDate date],SCRecordSessionDirectoryKey:SCRecordSessionDocumentDirectory};
}

// delegate
- (void)assetExportSessionDidProgress:(SCAssetExportSession *__nonnull)assetExportSession
{
    // 导出进度条
    if (self.delegate && [self.delegate respondsToSelector:@selector(mergeProgress:)]) {
        [self.delegate mergeProgress:assetExportSession.progress];
    }
}

//- (BOOL)assetExportSession:(SCAssetExportSession *__nonnull)assetExportSession shouldReginReadWriteOnInput:(AVAssetWriterInput *__nonnull)writerInput fromOutput:(AVAssetReaderOutput *__nonnull)output
//{
//
//}

//- (BOOL)assetExportSessionNeedsInputPixelBufferAdaptor:(SCAssetExportSession *__nonnull)assetExportSession
//{
//
//}

@end
