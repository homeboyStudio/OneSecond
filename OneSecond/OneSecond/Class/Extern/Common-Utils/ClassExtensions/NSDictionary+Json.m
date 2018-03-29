//
//  NSDictionary+Json.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    return [NSDictionary dictionaryWithJsonData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData
{
    __autoreleasing NSError * error;
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return dictionary;
}

- (NSString *)jsonString
{
    NSString *result = @"";
    __autoreleasing NSError * error;
    NSData * data = nil;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }@catch (NSException *exception) {
    }
    return result;
}

@end

