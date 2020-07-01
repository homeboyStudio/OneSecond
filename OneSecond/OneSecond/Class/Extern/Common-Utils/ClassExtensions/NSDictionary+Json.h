//
//  NSDictionary+Json.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;

- (NSString *)jsonString;

@end
