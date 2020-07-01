//
//  DBManager.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DBDateUtils.h"

@interface DBManager : NSObject

+ (DBManager *)shareDBManger;

- (NSArray *)getAllDateFromDataBase;

- (BOOL)insertDateModelToDB:(NSDictionary *)dictionary;

- (BOOL)updateDateModelWithDB:(NSDictionary *)dictionary;

- (BOOL)deleteDateModelWithDB:(NSString *)primaryKey;

- (BOOL)existDateModelWithDB:(NSString *)primaryKey;

- (NSUInteger)countDateModelWithDB;

@end
