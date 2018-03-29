//
//  WeixinActivity.m
//  WeixinActivity
//
//  Created by Johnny iDay on 13-12-2.
//  Copyright (c) 2013年 Johnny iDay. All rights reserved.
//

#import "WeixinActivityBase.h"

@implementation WeixinActivityBase

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        for (id activityItem in activityItems) {
            if ([activityItem isKindOfClass:[UIImage class]]) {
                return YES;
            }
            if ([activityItem isKindOfClass:[NSURL class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[UIImage class]]) {
            image = activityItem;
            // 如果截取的图片存才则替换为截取图片分享
            if (_cutImage) {
                image = _cutImage;
            }
        }
        if ([activityItem isKindOfClass:[NSURL class]]) {
            url = activityItem;
        }
        if ([activityItem isKindOfClass:[NSString class]]) {
            title = activityItem;
        }
    }
}

- (void)setThumbImage:(SendMessageToWXReq *)req
{
    if (image) {
        CGFloat width = 200.0f;
        CGFloat height = image.size.height * 200.0f / image.size.width;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [req.message setThumbImage:scaledImage];
    }
}

- (void)performActivity
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = scene;
//    req.bText = NO;
    req.message = WXMediaMessage.message;
    if (scene == WXSceneSession) {
        req.message.title = @"分享来自一秒";
        req.message.description = title;
    } else {
        req.message.title = title;
//        req.message.description = title;
//        req.message.mediaTagName = title;
    }
    [self setThumbImage:req];
    
    if (url) {
        WXWebpageObject *webObject = WXWebpageObject.object;
        webObject.webpageUrl = [url absoluteString];
        req.message.mediaObject = webObject;
    } else if (image) {
        WXImageObject *imageObject = WXImageObject.object;
        imageObject.imageData = UIImageJPEGRepresentation(image, 1);
        req.message.mediaObject = imageObject;
    }
    [WXApi sendReq:req];
    [self activityDidFinish:YES];
}

@end
