//
//  DBDateUtils.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "DBDateUtils.h"
#import "DBManager.h"
#import "NSString+Check.h"

@implementation OSDateModel

@end



@implementation DBDateUtils

+ (NSDictionary *)getAllDateModelDictionaryFromDateBase
{
    NSArray *dicArray = [[DBManager shareDBManger] getAllDateFromDataBase];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if ([dicArray count] > 0) {
        //  反序列化
        for (NSDictionary *dic in dicArray) {
            OSDateModel *model = [[OSDateModel alloc] init];
            model.date = [dic objectForKey:DATE];
            model.video_url = [dic objectForKey:VIDEO_URL];
            model.image_url = [dic objectForKey:IMAGE_URL];
            model.location = [dic objectForKey:LOCATION];
            [dictionary setObject:model forKey:model.date];
        }
        return [NSDictionary dictionaryWithDictionary:dictionary];
    }else {
        return nil;
    }
}


+ (NSArray *)getAllDateModelFromDateBase
{
   NSArray *dicArray = [[DBManager shareDBManger] getAllDateFromDataBase];
    NSMutableArray *array = [NSMutableArray array];
    
    if ([dicArray count] > 0) {
        // 反序列化
        for (NSDictionary *dic in dicArray) {
            OSDateModel *model = [[OSDateModel alloc] init];
            model.date = [dic objectForKey:DATE];
            model.video_url = [dic objectForKey:VIDEO_URL];
            model.image_url = [dic objectForKey:IMAGE_URL];
            model.location = [dic objectForKey:LOCATION];
            [array addObject:model];
        }
        return [NSArray arrayWithArray:array];
    }else {
        return nil;
    }
}

+ (BOOL)addDateModelToDataBase:(OSDateModel *)dateModel
{
    if (dateModel != nil) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:dateModel.date forKey:DATE];
        [dic setObject:dateModel.video_url forKey:VIDEO_URL];
        
        if ([NSString emptyOrNull:dateModel.image_url]) {
            [dic setObject:@"" forKey:IMAGE_URL];
        }else {
            [dic setObject:dateModel.image_url forKey:IMAGE_URL];
        }
        
        if ([NSString emptyOrNull:dateModel.location]) {
            [dic setObject:@"" forKey:LOCATION];
        }else {
            [dic setObject:dateModel.location forKey:LOCATION];
        }

      return [[DBManager shareDBManger] insertDateModelToDB:[NSDictionary dictionaryWithDictionary:dic]];
    }
    return NO;
}

+ (BOOL)updateDataModelWithDataBase:(OSDateModel *)dateModel
{
    if (dateModel != nil) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:dateModel.date forKey:DATE];
        [dic setObject:dateModel.video_url forKey:VIDEO_URL];
        if ([NSString emptyOrNull:dateModel.image_url]) {
            [dic setObject:@"" forKey:IMAGE_URL];
        }else {
            [dic setObject:dateModel.image_url forKey:IMAGE_URL];
        }

        if ([NSString emptyOrNull:dateModel.location]) {
            [dic setObject:@"" forKey:LOCATION];
        }else {
            [dic setObject:dateModel.location forKey:LOCATION];
        }
        return [[DBManager shareDBManger] updateDateModelWithDB:[NSDictionary dictionaryWithDictionary:dic]];
    }else
    {
        return NO;
    }
}

+ (BOOL)deleteDateModelWithDataBase:(NSString *)date
{
    if (![NSString emptyOrNull:date]) {

       return [[DBManager shareDBManger] deleteDateModelWithDB:date];
        
    }else {
    return NO;
    }
}

+ (BOOL)existDateModelWithDataBase:(NSString *)date
{
    if (![NSString emptyOrNull:date]) {
        
        return [[DBManager shareDBManger] existDateModelWithDB:date];
        
    }else {
        return NO;
    }
}

+ (NSUInteger)countOfDateModelWithDateBase
{
    return [[DBManager shareDBManger] countDateModelWithDB];
}

@end
