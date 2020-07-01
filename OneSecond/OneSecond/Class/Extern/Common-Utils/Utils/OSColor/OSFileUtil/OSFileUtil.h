//
//  OSFileUtil.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSFileUtil : NSObject
@property (nonatomic, strong) NSString *string;

// 获取Documents目录路径的方法
+ (NSString *)getFilePathStringWithDocument:(NSString *)fileName;

+ (NSURL *)getFilePathURLWithDocument:(NSString *)fileName;

@end
