//
//  OSGuidingViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/16.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSGuidingViewModel : NSObject


+ (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl;

+ (NSAttributedString *)getAttributedString:(NSString *)string lineSpacing:(CGFloat)spacing fontSize:(CGFloat)fontSize;

@end
