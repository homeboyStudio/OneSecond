//
//  OSNextDayModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
* comment1 和 comment2 分别对应 NextDay v4.5 版本之前每天的两行文字。
* 在 NextDay v4.5 之后，添加了 short 属性，即文字由双行被精简为单行。为了兼容既有的客户端，
* comment1 和 comment2 也被保留。short 并不是 comment1 和 comment2 的简单叠加。
* 由于历史原因，调用者不能假设每天的数据一定有 short 属性。随着时间的推移，我们希望最终仅仅需要维护 short 属性。
* https://github.com/sanddudu/nextday-desktop/wiki/API  API变更
*
* {img}   应该被替换为：https://upimg.nxmix.com/
* {music} 应该被替换为：https://upfile.nxmix.com/
* {video} 应该被替换为：https://upfile.nxmix.com/
*/
@interface TextModel : NSObject

@property (nonatomic, copy) NSString *comment1;
@property (nonatomic, copy) NSString *comment2;
@property (nonatomic, copy) NSString *shortComment;   // short
@property (nonatomic, copy) NSString *watchTitle;     // Apple Watch
@property (nonatomic, copy) NSString *watchBody;      // Apple Watch

@end

// ** 每日音乐信息 ** //
@interface MusicModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nitingCode;

@end


@interface WatchIconsModel : NSObject

@property (nonatomic, copy) NSString *size_38_icon;        // Apple Watch
@property (nonatomic, copy) NSString *size_42_icon;        // Apple Watch

@end


@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *autoPlay;
@property (nonatomic, copy) NSString *autoRepeat;
@property (nonatomic, copy) NSString *url;
//@property (nonatomic, copy) NSNumber *width;
//@property (nonatomic, copy) NSNumber *height;
//@property (nonatomic, copy) NSNumber *length;
@property (nonatomic, copy) NSString *orientation;

@end


// ** 各种尺寸的图片源 **//
@interface ImagesModel : NSObject

@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *small2x;
@property (nonatomic, copy) NSString *small568h2x;
@property (nonatomic, copy) NSString *big;
@property (nonatomic, copy) NSString *big2x;                // 3.5
@property (nonatomic, copy) NSString *big568h2x;            // 4.0 4.7
@property (nonatomic, copy) NSString *big568h3x;            // 5.5

@end



@interface OSNextDayModel : NSObject

@property (nonatomic, copy) NSString *dateKey;    // 当前数据代表的日期
@property (nonatomic, copy) NSString *authorName; // 作者信息
@property (nonatomic, copy) NSString *reverse;    // 地理信息。reverse 属性标明图片所在位置（城市,国家）
@property (nonatomic, copy) NSString *background; // 定义 NextDay 日历数据用到的颜色
@property (nonatomic, copy) NSString *event;      // 日历上的特殊日期描述，例如：“NX 特别日”，“立秋” 等  ********


@property (nonatomic, strong) TextModel        *textModel;
@property (nonatomic, strong) MusicModel       *musicModel;
@property (nonatomic, strong) WatchIconsModel  *watchIconsModel;
@property (nonatomic, strong) VideoModel       *videoModel;
@property (nonatomic, strong) ImagesModel      *imagesModel;

@property (nonatomic, copy) NSString *imageHeaderUrl;  // 拼接字符串 图片资源
@property (nonatomic, copy) NSString *mediaHeaderUrl;  // 拼接字符串 视频or音频

@end




