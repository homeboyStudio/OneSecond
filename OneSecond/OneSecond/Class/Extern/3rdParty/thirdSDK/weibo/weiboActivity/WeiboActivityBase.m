//
//  WeiboActivityBase.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/16.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "WeiboActivityBase.h"
#import "WeiboSDK.h"
#import "NSString+Check.h"

@implementation WeiboActivityBase

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

// override this to return availability of activity based on items. default returns NO
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP]) {
        for (id activityItem in activityItems) {
            if ([activityItem isKindOfClass:[UIImage class]]) return YES;
            if ([activityItem isKindOfClass:[NSURL class]]) return YES;
        }
    }
    return NO;
}

// override to extract items and set up your HI. default does nothing
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
            detailText = activityItem;
        }
    }
}

// if no view controller, this method is called. call activityDidFinish when done. default calls [self activityDidFinish:NO]
- (void)performActivity
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:nil access_token:@"d3b35c403311cca19597b6cee0a9ccc1"];
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *shareObject = [[WBMessageObject alloc] init];
    shareObject.text = detailText;
    if ([NSString emptyOrNull:detailText]) {
        shareObject.text = @"";
    }else {
        shareObject.text = detailText;
    }
    
    if (image != nil) {
       WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImagePNGRepresentation(image);
        shareObject.imageObject = imageObject;
    }
    
    if (url != nil) {
        NSString *urlString = url.absoluteString;
        shareObject.text = [NSString stringWithFormat:@"%@ 分享来自：%@",shareObject.text, urlString];
    }
    
    return shareObject;
}

@end
