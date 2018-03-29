//
//  DBDateUtils.h
//  OneSecond
//
//  Created by JHR on 15/10/25.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE      @"DATE"                // 主键
#define VIDEO_URL @"VIDEO_URL"           // 视频地址URL
#define IMAGE_URL @"IMAGE_URL"           // 缩略图地址URL
#define LOCATION  @"LOCATION"            // 地理位置

@interface OSDateModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *location;

@end

@interface DBDateUtils : NSObject

/*
 *  获得数据库中所有的反序列化的dateModel字典集合，key为date
 */
+ (NSDictionary *)getAllDateModelDictionaryFromDateBase;

/*
 *  获得数据库中所有的反序列化的dateModel集合
 */
+ (NSArray *)getAllDateModelFromDateBase;

/*
*  传入一个OSDateModel对象序列化插入到数据库中
*/
+ (BOOL)addDateModelToDataBase:(OSDateModel *)dateModel;

/*
 *  更新数据库中一行，传入一个OSDateModel对象
 */
+ (BOOL)updateDataModelWithDataBase:(OSDateModel *)dateModel;

/*
*  删除数据库中的一行数据，通过PrimaryKey：DATE
*/
+ (BOOL)deleteDateModelWithDataBase:(NSString *)date;

/*
*  查询数据库中一行数据是否存在
*/
+ (BOOL)existDateModelWithDataBase:(NSString *)date;

/*
*  获得表中所有数据总数
*/
+ (NSUInteger)countOfDateModelWithDateBase;

@end
