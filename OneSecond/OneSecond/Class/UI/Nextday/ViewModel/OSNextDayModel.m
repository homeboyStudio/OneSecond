//
//  OSNextDayModel.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/26.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSNextDayModel.h"

@implementation TextModel
@end

@implementation MusicModel
@end

@implementation WatchIconsModel
@end

@implementation VideoModel
@end

@implementation ImagesModel
@end


@implementation OSNextDayModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageHeaderUrl = @"http://nextday-pic.b0.upaiyun.com";
        self.mediaHeaderUrl = @"http://nextday-file.b0.upaiyun.com";
    }
    return self;
}

@end





