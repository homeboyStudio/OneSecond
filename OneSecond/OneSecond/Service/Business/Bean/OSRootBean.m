//
//  OSRootBean.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSRootBean.h"

@interface OSRootBean()

/** http 参数 */
@property(nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation OSRootBean

- (instancetype)init
{
    self = [super init];
    if (self) {
        _parameters = [[NSMutableDictionary alloc] init];
        if (__dataSource != nil) {
            // 初始化一些通用参数
//            [_parameters setValue:__dataSource.device_token forKey:DEVICE_TOKEN];
        }
    }
    return self;
}

- (void)bindValue:(id)value forKey:(NSString *)key
{
    if (value !=nil) {
        [self.parameters setValue:value forKey:key];
    }else {
        [self.parameters setValue:@"" forKey:key];
    }
}

- (void)bindStringValue:(NSString *)value forKey:(NSString *)key
{
    [self.parameters setValue:value forKey:key];
}

- (void)bindIntValue:(NSInteger)value forKey:(NSString *)key
{
    NSNumber *number = [NSNumber numberWithInteger:value];
    [self.parameters setValue:number forKey:key];
}

- (void)bindByteValue:(id)value forKey:(NSString *)key
{
    [self.parameters setValue:value forKey:key];
}

- (void)setProperty:(NSDictionary *)dic
{
    self.parameters = [dic mutableCopy];
}

- (NSDictionary *)getProperty
{
    if ([[self.parameters allKeys] count] == 0) {
        return nil;
    }else {
        return self.parameters;
    }
}

/** get http request propertyJSON */
//- (NSData *)getPropertyJSONData{
//    NSData *data = nil;
//    NSString *result = [self.parameters jsonString];
//    if (![NSString emptyOrNull:result]) {
//        data = [result dataUsingEncoding:NSUTF8StringEncoding];
//    }
//   
//    return data;
//}

@end
