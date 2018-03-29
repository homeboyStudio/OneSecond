//
//  OSMovieClipViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//   

#import <Foundation/Foundation.h>

typedef void (^ProgressSuccessBlock)(BOOL success, NSError *error, NSString *filePathString);

@interface OSMovieClipViewModel : NSObject

- (void)startClipProgressWithBlock:(ProgressSuccessBlock)success;

- (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl;

@end
