//
//  DBManager.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "DBManager.h"
#import "NSString+Check.h"

static DBManager *__dbManager;
static NSString *DATABASE_NAME = @"OneSecond.db";
static NSString *DataTableName = @"DateTable";

@interface DBManager()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DBManager


+ (DBManager *)shareDBManger
{
   static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        __dbManager = [[DBManager alloc] init];
    });
    
    return __dbManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:DATABASE_NAME];
        self.database = [FMDatabase databaseWithPath:dbpath];
    }
    return self;
}

#pragma mark ----------------- 接口API ------------------------

- (NSArray *)getAllDateFromDataBase
{
     // 按照升序排序
     if ([self.database open]) {
        NSString *selectedSql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ ASC",DataTableName, DATE];
        FMResultSet *resultSet = [self.database executeQuery:selectedSql];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        while ([resultSet next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSString *date = [resultSet stringForColumn:DATE];
            NSString *video_url = [resultSet stringForColumn:VIDEO_URL];
            NSString *image_url = [resultSet stringForColumn:IMAGE_URL];
            NSString *location = [resultSet stringForColumn:LOCATION];
            [dic setObject:date forKey:DATE];
            [dic setObject:video_url forKey:VIDEO_URL];
            [dic setObject:image_url forKey:IMAGE_URL];
            [dic setObject:location forKey:LOCATION];
            [dataArray addObject:dic];
        }
        [self.database close];
        return [NSArray arrayWithArray:dataArray];
    }else {
        // 错误处理
        return nil;
    }
}

- (BOOL)insertDateModelToDB:(NSDictionary *)dictionary
{
    if ([self.database open]) {
        NSString *date = [dictionary objectForKey:DATE];
        NSString *video_url = [dictionary objectForKey:VIDEO_URL];
        NSString *image_url = [dictionary objectForKey:IMAGE_URL];
        NSString *location = [dictionary objectForKey:LOCATION];

        NSString *insertSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@') VALUES (COALESCE((SELECT '%@' FROM '%@' WHERE '%@' = '%@'), '%@'), '%@', '%@', '%@')",DataTableName, DATE, VIDEO_URL, IMAGE_URL, LOCATION, DATE, DataTableName, DATE, date, date, video_url, image_url, location];
        
//        NSString *insertSql = [NSString stringWithFormat: @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')", DataTableName, DATE, VIDEO_URL, IMAGE_URL, LOCATION, date, video_url, image_url, location];
        BOOL success = [self.database executeUpdate:insertSql];
        [self.database close];
        return success;
    }else {
        return NO;
    }
}

- (BOOL)updateDateModelWithDB:(NSDictionary *)dictionary
{
    if ([self.database open]) {
        NSString *date = [dictionary objectForKey:DATE];
        NSString *video_url = [dictionary objectForKey:VIDEO_URL];
        NSString *image_url = [dictionary objectForKey:IMAGE_URL];
        NSString *location = [dictionary objectForKey:LOCATION];
        
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",DataTableName, VIDEO_URL, video_url, IMAGE_URL, image_url, LOCATION, location, DATE, date];
        
      BOOL success = [self.database executeUpdate:updateSql];
        [self.database close];
        return success;
    }else {
        // 打开数据库失败
        return NO;
    }
    return YES;
}

- (BOOL)deleteDateModelWithDB:(NSString *)primaryKey
{
    return YES;
}

- (BOOL)existDateModelWithDB:(NSString *)primaryKey
{
    if ([self.database open]) {

        NSString *selectedSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %@",DATE, DataTableName, DATE, primaryKey];
        
        FMResultSet *resultSet = [self.database executeQuery:selectedSql];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        while ([resultSet next]) {
            NSString *date = [resultSet stringForColumn:DATE];
            if (![NSString emptyOrNull:date]) {
                [dataArray addObject:date];
            }
        }
        [self.database close];
        if (dataArray.count == 1 && [dataArray[0] isEqualToString:primaryKey]) {
            return YES;
        }else {
            return NO;
        }

        
    }else {
        // 打开数据库失败
        return NO;
    }
    
    return YES;
}

- (NSUInteger)countDateModelWithDB
{
    if ([self.database open]) {
        
        NSString *countSql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",DataTableName];
        FMResultSet *resultSet = [self.database executeQuery:countSql];
        NSUInteger count = 0;
        while ([resultSet next]) {
             NSDictionary *dic = [resultSet resultDictionary];
            count = [[dic objectForKey:@"COUNT(*)"] unsignedIntegerValue];
        };
        
        return count;
    }else {
        return 0;
    }
}

@end
