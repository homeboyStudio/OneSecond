//
//  OSNextDayModel.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
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
     //Wiki： https://github.com/sanddudu/nextday-desktop/wiki/API
        self.imageHeaderUrl = @"https://upimg.nxmix.com/";
        self.mediaHeaderUrl = @"https://upfile.nxmix.com/";
    }
    return self;
}

@end





