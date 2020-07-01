//
//  OSFileUtil.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSFileUtil.h"

@implementation OSFileUtil

+ (NSString *)getFilePathStringWithDocument:(NSString *)fileName
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [paths stringByAppendingPathComponent:fileName];
}

+ (NSURL *)getFilePathURLWithDocument:(NSString *)fileName
{
    return [NSURL fileURLWithPath:[self getFilePathStringWithDocument:fileName]];
}

@end
