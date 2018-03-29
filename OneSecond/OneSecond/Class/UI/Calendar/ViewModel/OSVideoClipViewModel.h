//
//  OSVideoClipViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 16/1/31.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^getPlayerItemsBlock) (NSArray *itemsArray, float duration);

@protocol OSVideoClipViewModelDelegate <NSObject>

@optional

- (void)mergeProgress:(CGFloat)progress;
- (void)mergeResultWithError:(NSError *)error;

@end

@interface OSVideoClipViewModel : NSObject

@property (nonatomic, weak) id<OSVideoClipViewModelDelegate> delegate;

- (void)getPlayerItemsWithBlock:(getPlayerItemsBlock)success;

- (void)startMergeVideo;

@end
