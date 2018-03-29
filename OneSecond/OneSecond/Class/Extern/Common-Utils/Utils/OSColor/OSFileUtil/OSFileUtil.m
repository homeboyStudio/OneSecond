//
//  OSFileUtil.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/1.
//  Copyright © 2015年 com.homeboy. All rights reserved.
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
