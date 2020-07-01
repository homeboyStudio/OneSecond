//
//  OSGuidingViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSGuidingViewModel : NSObject


+ (AVPlayerItem *)getPlayItemWithVideoUrlString:(NSString *)videoUrl;

+ (NSAttributedString *)getAttributedString:(NSString *)string lineSpacing:(CGFloat)spacing fontSize:(CGFloat)fontSize;

@end
