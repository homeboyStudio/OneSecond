//
//  OSReplayViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/14.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBDateUtils.h"

typedef void (^AddWatermarkToVideoBlock) (BOOL Success);

@interface OSReplayViewModel : NSObject

- (void)startAddWatermarkToVideoWithURL:(NSURL *)videoUrl dateModel:(OSDateModel *)dateModel successBlock:(AddWatermarkToVideoBlock)success;

@end
