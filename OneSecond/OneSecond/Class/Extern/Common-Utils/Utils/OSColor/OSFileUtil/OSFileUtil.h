//
//  OSFileUtil.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/1.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSFileUtil : NSObject
@property (nonatomic, strong) NSString *string;

// 获取Documents目录路径的方法
+ (NSString *)getFilePathStringWithDocument:(NSString *)fileName;

+ (NSURL *)getFilePathURLWithDocument:(NSString *)fileName;

@end
