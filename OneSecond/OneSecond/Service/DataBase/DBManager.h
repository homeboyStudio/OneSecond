//
//  DBManager.h
//  OneSecond
//
//  Created by JHR on 15/10/25.
//  Copyright © 2015年 com.homeboy. All rights reserved.
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
