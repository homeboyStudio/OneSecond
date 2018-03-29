//
//  NSDictionary+Json.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;

- (NSString *)jsonString;

@end
