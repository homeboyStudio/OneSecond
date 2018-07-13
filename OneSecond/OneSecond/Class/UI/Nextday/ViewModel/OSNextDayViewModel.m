//
//  OSNextDayViewModel.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/30.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSNextDayViewModel.h"
#import "OSNextDayModel.h"
#import "OSDateUtil.h"
#import "NSString+Check.h"

// keys
#define DateKey    @"dateKey"
#define Author     @"author"      // 可能为空
#define Text       @"text"
#define Geo        @"geo"
#define Event      @"event"       // 可能为空
#define Music      @"music"
#define Colors     @"colors"
#define WatchIcons @"watchIcons"
#define Video      @"video"       // 可能为空
#define Images     @"images"
//#define Timezone   @"timezone"
//#define Thumbnail  @"thumbnail"
//#define ModifiedAt @"modifiedAt"

@interface OSNextDayViewModel()

@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSArray *weekdayArray;

@end

@implementation OSNextDayViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.monthArray = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
        self.weekdayArray = @[@"SUNDAY",@"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY",@"SATURDAY"];
    }
    return self;
}


- (OSNextDayModel *)convertToNextDayModel:(NSDictionary *)dictionary
{
    OSNextDayModel *_nextDayModel = [[OSNextDayModel alloc] init];
    
    NSString *key = [[dictionary allKeys] firstObject];
    NSDictionary *values = [dictionary objectForKey:key];
    for (NSString *key in [values allKeys]) {
        if ([key isEqualToString:DateKey]) {
            
            _nextDayModel.dateKey = [values objectForKey:key];
            
        }else if ([key isEqualToString:Author]) {
            
            NSDictionary *authorDic = [values objectForKey:key];
            _nextDayModel.authorName = [authorDic objectForKey:@"name"];
            
        }else if ([key isEqualToString:Text]) {
            NSDictionary *textModelDic =  [values objectForKey:key];
            _nextDayModel.textModel =  [[TextModel alloc] init];
            _nextDayModel.textModel.comment1 =     [textModelDic objectForKey:@"comment1"];
            _nextDayModel.textModel.comment2 =     [textModelDic objectForKey:@"comment2"];
            _nextDayModel.textModel.shortComment = [textModelDic objectForKey:@"short"];
            _nextDayModel.textModel.watchTitle =   [textModelDic objectForKey:@"watchTitle"];
            _nextDayModel.textModel.watchBody =    [textModelDic objectForKey:@"watchBody"];
            
        }else if ([key isEqualToString:Geo]) {
            NSDictionary *geoDic =  [values objectForKey:key];
            _nextDayModel.reverse = [geoDic objectForKey:@"reverse"];
            
        }else if ([key isEqualToString:Event]){
            _nextDayModel.event = [values objectForKey:key];
            
        }else if ([key isEqualToString:Colors]) {
            NSDictionary *colors = [values objectForKey:key];
            _nextDayModel.background = [colors objectForKey:@"background"];
            
        }else if ([key isEqualToString:Music]) {
            NSDictionary *musicDic = [values objectForKey:key];
            _nextDayModel.musicModel = [[MusicModel alloc] init];
            _nextDayModel.musicModel.title =      [musicDic objectForKey:@"title"];
            _nextDayModel.musicModel.artist =     [musicDic objectForKey:@"artist"];
            _nextDayModel.musicModel.url =        [[musicDic objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"{music}" withString:_nextDayModel.mediaHeaderUrl];
            _nextDayModel.musicModel.name =       [musicDic objectForKey:@"name"];
            _nextDayModel.musicModel.nitingCode = [musicDic objectForKey:@"nitingCode"];
            
        }else if ([key isEqualToString:WatchIcons]) {
            NSDictionary *watchIconDic = [values objectForKey:WatchIcons];
            _nextDayModel.watchIconsModel = [[WatchIconsModel alloc] init];
            _nextDayModel.watchIconsModel.size_38_icon = [[watchIconDic objectForKey:@"38"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.watchIconsModel.size_42_icon = [[watchIconDic objectForKey:@"42"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            
        }else if ([key isEqualToString:Video]) {
            NSDictionary *videoDic = [values objectForKey:Video];
            _nextDayModel.videoModel = [[VideoModel alloc] init];
            _nextDayModel.videoModel.autoPlay =     [videoDic objectForKey:@"autoPlay"];      // 1
            _nextDayModel.videoModel.autoRepeat =   [videoDic objectForKey:@"autoRepeat"];    // 1
            _nextDayModel.videoModel.url =          [[videoDic objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"{video}" withString:_nextDayModel.mediaHeaderUrl];
            //            _nextDayModel.videoModel.width =        [videoDic objectForKey:@"width"];
            //            _nextDayModel.videoModel.height =       [videoDic objectForKey:@"height"];
            //            _nextDayModel.videoModel.length =       [videoDic objectForKey:@"length"];
            _nextDayModel.videoModel.orientation =  [videoDic objectForKey:@"orientation"];
            
        }else if ([key isEqualToString:Images]) {
            NSDictionary *imageDic = [values objectForKey:Images];
            _nextDayModel.imagesModel = [[ImagesModel alloc] init];
            _nextDayModel.imagesModel.small =        [[imageDic objectForKey:@"small"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.imagesModel.small2x =      [[imageDic objectForKey:@"small2x"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.imagesModel.small568h2x =  [[imageDic objectForKey:@"small568h2x"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.imagesModel.big =          [[imageDic objectForKey:@"big"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.imagesModel.big2x =        [[imageDic objectForKey:@"big2x"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.imagesModel.big568h2x =    [[imageDic objectForKey:@"big568h2x"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
            _nextDayModel.imagesModel.big568h3x =    [[imageDic objectForKey:@"big568h3x"] stringByReplacingOccurrencesOfString:@"{img}" withString:_nextDayModel.imageHeaderUrl];
        }
    }
    return _nextDayModel;
}

- (NSString *)getBigDayWithDate:(NSString *)date
{
   return [date substringWithRange:NSMakeRange(6, 2)];
}

- (NSString *)getDateStringWithDate:(NSDate *)date String:(NSString *)dateString event:(NSString *)event;
{
    NSInteger month = [[dateString substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSString *monthString = [self.monthArray objectAtIndex:(month - 1)];
    
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [componets weekday];
    NSString *weekDayString = [self.weekdayArray objectAtIndex:(weekDay - 1)];
    
    if (![NSString emptyOrNull:event]) {
        return [NSString stringWithFormat:@"%@. %@, %@",monthString, weekDayString, event];
    }else {
        return [NSString stringWithFormat:@"%@. %@",monthString, weekDayString];
    }
}

#pragma mark ---------------------- 视频播放 ----------------------------
/**
 *  根据视频地址取得AVPlayerItem对象
 *
 *  @param videoUrl 视频地址
 *
 *  @return AVPlayerItem对象
 */
+ (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl
{
    NSURL *url = [NSURL URLWithString:[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    return playItem;
}

- (void)saveImageToPhotoWithImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

}

@end
