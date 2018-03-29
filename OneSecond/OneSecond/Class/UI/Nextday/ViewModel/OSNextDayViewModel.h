//
//  OSNextDayViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/30.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OSNextDayModel;

@interface OSNextDayViewModel : NSObject

- (OSNextDayModel *)convertToNextDayModel:(NSDictionary *)dictionary;

- (NSString *)getBigDayWithDate:(NSString *)date;

- (NSString *)getDateStringWithDate:(NSDate *)date String:(NSString *)dateString event:(NSString *)event;


/**
 *  根据视频地址取得AVPlayerItem对象
 *
 *  @param videoUrl 视频地址
 *
 *  @return AVPlayerItem对象
 */
+ (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl;

- (void)saveImageToPhotoWithImage:(UIImage *)image;

@end
