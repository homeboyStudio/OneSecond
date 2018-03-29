//
//  GenericModel.m
//  GenericModel
//
//  Created by zyma on 5/1/15.
//  Copyright (c) 2015 zyma678. All rights reserved.
//

#import "GenericModel.h"
#import <objc/runtime.h>

//#define GENERIC_DEBUG_ENV

//#ifdef GENERIC_DEBUG_ENV
//#define DLog(format, ...) NSLog((@"%s@%d: " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#define DLog(format, ...)
//#endif


/**  **************序列化解析器************** */
/** 序列化对象 */
id genSerializeObject(id obj, NSString *clazz);
/** 反序列化对象 */
id genDeserializeObject(id dic, NSString *clazz);
/** 序列化数组对象 */
NSArray * genSerializeArray(id obj, NSString *clazz);
/** 反序列化数组对象 */
NSArray * genDeserializeArray(id obj, NSString *clazz);
/** 序列化字典对象 */
NSDictionary * genSerializeDictionary(id obj, NSString *clazz);
/** 反序列化字典对象 */
NSDictionary * genDeserializeDictionary(id obj, NSString *clazz);
/** 序列化集合对象 */
NSSet * genSerializeSet(id obj, NSString *clazz);
/** 反序列化集合对象 */
NSSet * genDeserializeSet(id obj, NSString *clazz);

/** **************类型判断工具************** */
/** 获取类型符号 */
NSString *genGetPropertyTypeWithDescription(NSString *description);
/** 获取容器的泛型类型 */
NSString *genGetGenericType(NSString *propertyType);
/** 判断字CLass类型是否是JsonModel*/
BOOL genStringTypeIsGenModel(Class clazz);
/** 判断字符串类型是否是NSArray */
BOOL genStringTypeIsArray(NSString *type);
/** 判断对象是否是NSArray类型 */
BOOL genObjectTypeIsArray(id obj);
/** 判断字符串是否是NSDictionary类型 */
BOOL genStringTypeIsDictionary(NSString *type);
/** 判断对象是否是NSDictionary类型 */
BOOL genObjectTypeIsDictionary(id obj);
/** 判断字符串是否是NSSset类型 */
BOOL genStringTypeIsSet(NSString *type);
/** 判断对象是否是NSSset类型 */
BOOL genObjectTypeIsSet(id obj);
/** JSON->NSDictionary */
NSDictionary *JSONObject(NSString *jsonStr);
/** NSDictionary->JSON */
NSString *JSONString(NSDictionary *dic);

/** **************classinfo tools************** */
static NSMutableDictionary *__classDeclatedCacheMap;

@interface genModelDeclated : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pramDescription;
@end
@implementation genModelDeclated @end

/**获取第一层model，的第一个字段作为主键*/
NSString *genGetPrimaryKey(Class clazz);
/** 获取model的属性，包括父类的 */
NSArray *genGetPropertyDeclared(Class clazz);

@implementation GenericModel


static NSArray *enumIntFlagArray = NULL;

+ (id)getObjectByDictionary:(NSDictionary *)dic clazz:(Class)clazz{
    id result = nil;
    if (genStringTypeIsGenModel(clazz)) {
        result = genDeserializeObject(dic, NSStringFromClass(clazz));
    }
    return result;
}

+ (id)getObjectByJSON:(NSString *)json clazz:(Class)clazz{
    NSDictionary *dic = JSONObject(json);
    if (dic) {
        return [GenericModel getObjectByDictionary:dic clazz:clazz];
    }else{
        return nil;
    }
}

+ (NSDictionary *)getDictionaryByObject:(id)object{
    Class clazz = [object class];
    id result = nil;
    if (genStringTypeIsGenModel(clazz)) {
        result = genSerializeObject(object, NSStringFromClass(clazz));
    }
    return result;
}

+ (NSString *)getJSONByObject:(id)object{
    NSDictionary *dicResult = [GenericModel getDictionaryByObject:object];
    return JSONString(dicResult);
}

#pragma mark - --------------------classinfo tools--------------------
#pragma mark 获取第一层model，的第一个字段作为主键
NSString *genGetPrimaryKey(Class clazz){
    NSString *clazz_s = NSStringFromClass(clazz);
    NSArray *classDeclates = [__classDeclatedCacheMap objectForKey:clazz_s];
    NSString *result = @"";
    if (classDeclates && [classDeclates count]>0) {
        genModelDeclated *declatedModel = [classDeclates objectAtIndex:0];
        result = declatedModel.name;
    }
    return result;
}
#pragma mark 获取model的属性，包括父类的
NSArray *genGetPropertyDeclared(Class clazz){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __classDeclatedCacheMap = [[NSMutableDictionary alloc] init];
    });
    NSMutableArray *resultArray = nil;
    NSString *clazz_s = NSStringFromClass(clazz);
    NSArray *cache = [__classDeclatedCacheMap objectForKey:clazz_s];
    if (cache && [cache count]>0) {
        resultArray = [NSMutableArray arrayWithArray:cache];
    }else{
        resultArray = [[NSMutableArray alloc] init];
        while (genStringTypeIsGenModel(clazz)){
            unsigned int numberOfProperties = 0;
            objc_property_t *properties = class_copyPropertyList(clazz, &numberOfProperties);
            for (int i = 0; i < numberOfProperties; i++) {
                objc_property_t property = properties[i];
                const char *name_c = property_getName(property);
                const char *description_c = property_getAttributes(property);
                NSString *name_s = [NSString stringWithUTF8String:name_c];
                NSString *description_s = [NSString stringWithUTF8String:description_c];
                genModelDeclated *declatedModel = [[genModelDeclated alloc] init];
                declatedModel.name = name_s;
                declatedModel.pramDescription = description_s;
                [resultArray addObject:declatedModel];
            }
            clazz = class_getSuperclass(clazz);
            free(properties);
        }
    }
    if ([__classDeclatedCacheMap objectForKey:clazz_s] == nil) {
        [__classDeclatedCacheMap setValue:resultArray forKey:clazz_s];
    }
    return resultArray;
}

#pragma mark - --------------------serialize--------------------
#pragma mark 序列化对象
id  genSerializeObject(id obj, NSString *clazz){
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    Class cla = NSClassFromString(clazz);
    if (genStringTypeIsGenModel(cla)) {
        NSArray *propertyDeclareds = genGetPropertyDeclared(cla);
        for (genModelDeclated *declatedModel in propertyDeclareds) {
            NSString *name_s = declatedModel.name;
            NSString *description_s = declatedModel.pramDescription;
            id object = [obj valueForKey:name_s];
            //            DLog(@"propertytype = %@\nname= %@ \nvalue = %@",description_s,name_s,object);
            if (object == NULL || name_s == NULL || description_s == NULL) {
                continue;
            }
            NSString *propertyType = genGetPropertyTypeWithDescription(description_s);
            id serializeObj = nil;
            if (genStringTypeIsGenModel(NSClassFromString(propertyType))) {
                serializeObj = genSerializeObject(object, propertyType);
            }else if ([description_s hasPrefix:@"T@\""]) {
                if (genStringTypeIsArray(propertyType)) {//序列化Array
                    serializeObj = genSerializeArray(object, propertyType);
                }else if (genStringTypeIsDictionary(propertyType)){//序列化Dictionary
                    serializeObj = genSerializeDictionary(object, propertyType);
                }else if (genStringTypeIsSet(propertyType)){//序列化set
                    serializeObj = genSerializeSet(object, propertyType);
                }else{
                    serializeObj = object;
                }
            }else{
                //支持KVC 的类型 v--void //*--char* //#--class //:--SEL//[] NOT supported
                if (enumIntFlagArray == NULL) {
                    enumIntFlagArray = @[@"c",@"C",@"i",@"I",@"s",@"S",@"l",@"L",@"q",@"Q",@"f",@"d",@"B"];
                }
                if ([enumIntFlagArray containsObject:propertyType]) {
                    serializeObj = object;
                }else{
                    DLog(@"warning 不支持的基础类型:obj=%@,clazz=%@,description=%@",object,name_s,description_s);
                    continue;
                }
                
            }
            [result setValue:serializeObj forKey:name_s];
        }
    }else if (genStringTypeIsArray(clazz)) {//解析Array
        return genSerializeArray(obj, clazz);
    }else if (genStringTypeIsDictionary(clazz)){//解析Dictionary
        return genSerializeDictionary(obj, clazz);
    }else if (genStringTypeIsSet(clazz)){//解析set
        return genSerializeSet(obj, clazz);
    }else{
        DLog(@"warning 不支持的基础类型:obj=%@,clazz=%@",obj,clazz);
    }
    return result;
}
#pragma mark 反序列化对象
id genDeserializeObject(id dic, NSString *clazz){
    Class cla = NSClassFromString(clazz);
    id result = [cla new];
    if (genStringTypeIsGenModel(cla)) {
        NSArray *propertyDeclareds = genGetPropertyDeclared(cla);
        for (genModelDeclated *declatedModel in propertyDeclareds) {
            NSString *name_s = declatedModel.name;
            NSString *description_s = declatedModel.pramDescription;
            id obj = nil;
            if ([dic respondsToSelector:@selector(objectForKey:)]) {
                obj = [dic objectForKey:name_s];
            }else{//如果不支持KVC说明 是一个Array、dic、set等容器类的对象，直接赋给obj
                if ([genGetPrimaryKey(cla) isEqualToString:name_s]){
                    obj = dic;
                }else{
                    DLog(@"error model 命名和服务接口不一致dic=%@,name_s=%@",dic,name_s);
                    //                    assert(0);
                    //                    assert([name_s isEqualToString:@"assert"]);
                    //                    assert([name_s isEqualToString:@"status_code"]);
                    //                    assert([name_s isEqualToString:@"status_message"]);
                    continue;
                }
            }
            
            if (obj == nil || (NSNull *)obj == [NSNull null] || name_s == nil || description_s == nil) {
                //                DLog(@"warning model字段为空 = %@\nname= %@ \nvalue = %@",description_s,name_s,obj);
                continue;
            }
            id serializeObj = nil;
            NSString *propertyType = genGetPropertyTypeWithDescription(description_s);
            /** object */
            if (genStringTypeIsGenModel(NSClassFromString(propertyType))) {
                serializeObj = genDeserializeObject(dic,propertyType);
            }else if ([description_s hasPrefix:@"T@\""]) {
                if (genStringTypeIsArray(propertyType)) {//解析Array
                    NSArray *array = genDeserializeArray(obj, propertyType);
                    serializeObj = array;
                }else if (genStringTypeIsDictionary(propertyType)){//解析Dictionary
                    NSDictionary *dic = genDeserializeDictionary(obj, propertyType);
                    serializeObj = dic;
                }else if (genStringTypeIsSet(propertyType)){//解析set
                    NSSet *set = genDeserializeSet(obj, propertyType);
                    serializeObj = set;
                }else{
                    serializeObj = obj;
                }
            }else{
                //支持KVC 的类型 v--void //*--char* //#--class //:--SEL//[] NOT supported
                if (enumIntFlagArray == NULL) {
                    enumIntFlagArray = @[@"c",@"C",@"i",@"I",@"s",@"S",@"l",@"L",@"q",@"Q",@"f",@"d",@"B"];
                }
                if ([enumIntFlagArray containsObject:propertyType]) {
                    serializeObj = obj;
                }else{
                    DLog(@"warning 不支持的基础类型:dic=%@,clazz=%@,description=%@",obj,name_s,description_s);
                    continue;
                }
            }
            [result setValue:serializeObj forKey:name_s];
        }
    }else if (genStringTypeIsArray(clazz)) {//解析Array
        return genDeserializeArray(dic, clazz);
    }else if (genStringTypeIsDictionary(clazz)){//解析Dictionary
        return genDeserializeDictionary(dic, clazz);
    }else if (genStringTypeIsSet(clazz)){//解析set
        return genDeserializeSet(dic, clazz);
    }else{
        DLog(@"warning 不支持的基础类型:dic=%@,clazz=%@",dic,clazz);
    }
    return result;
}

#pragma mark 序列化数组对象
NSArray * genSerializeArray(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = genGetGenericType(clazz);
    NSArray *array = [NSArray arrayWithArray:obj];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    if (genericType.length>0) {
        for (int i = 0; i < [array count]; i++) {
            id item = [array objectAtIndex:i];
            NSDictionary *dic = genSerializeObject(item, genericType);
            [resultArray addObject:dic];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultArray;
}

#pragma mark 反序列化数组对象
NSArray * genDeserializeArray(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = genGetGenericType(clazz);
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    if (genericType.length>0) {
        for (int i = 0; i < [obj count]; i++) {
            id item = [obj objectAtIndex:i];
            id model = genDeserializeObject(item, genericType);
            [resultArray addObject:model];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultArray;
}

#pragma mark 序列化字典对象
NSDictionary * genSerializeDictionary(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = genGetGenericType(clazz);
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if (genericType.length>0) {
        NSArray *keys = [obj allKeys];
        for (NSString * key in keys) {
            id item = [obj objectForKey:key];
            id model = genSerializeObject(item, genericType);
            [resultDic setObject:model forKey:key];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultDic;
}

#pragma mark 反序列化字典对象
NSDictionary *  genDeserializeDictionary(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = genGetGenericType(clazz);
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if (genericType.length>0) {
        NSArray *keys = [obj allKeys];
        for (NSString * key in keys) {
            id item = [obj objectForKey:key];
            id model = genDeserializeObject(item, genericType);
            [resultDic setObject:model forKey:key];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultDic;
}

#pragma mark 序列化集合对象
NSSet * genSerializeSet(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = genGetGenericType(clazz);
    NSMutableSet *resultSet = [NSMutableSet set];
    if (genericType.length>0) {
        NSEnumerator *enumerator = [obj objectEnumerator];
        for (id item in enumerator) {
            id model = genSerializeObject(item, genericType);
            [resultSet addObject:model];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultSet;
}

#pragma mark 反序列化集合对象
NSSet * genDeserializeSet(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = genGetGenericType(clazz);
    NSMutableSet *resultSet = [NSMutableSet set];
    if (genericType.length>0) {
        NSEnumerator *enumerator = [obj objectEnumerator];
        for (id item in enumerator) {
            id model = genDeserializeObject(item, genericType);
            [resultSet addObject:model];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultSet;
}

#pragma mark - --------------------tools--------------------

#pragma mark - JSON->NSDictionary
NSDictionary *JSONObject(NSString *jsonStr)
{
    return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}

NSString *JSONString(NSDictionary *dic){
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
}

#pragma mark - 获取类型符号
NSString *genGetPropertyTypeWithDescription(NSString *description)
{
    NSString *resultTypeString = nil;
    
    if (description.length > 0) {
        NSUInteger endIndex = [description rangeOfString:@","].location;
        if (endIndex != NSNotFound)
        {
            resultTypeString = [description substringWithRange:NSMakeRange(1, endIndex-1)];
            resultTypeString = [resultTypeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            resultTypeString = [resultTypeString stringByReplacingOccurrencesOfString:@"@" withString:@""];
        }
    }
    
    return resultTypeString;
}


#pragma mark - 判断类型
#pragma mark 获取容器的泛型类型
NSString *genGetGenericType(NSString *propertyType){
    NSString *genericType = @"";
    if ([propertyType rangeOfString:@"<"].location != NSNotFound) {
        NSUInteger startIndex = [propertyType rangeOfString:@"<"].location;
        NSUInteger endIndex = [propertyType rangeOfString:@">"].location;
        genericType = [propertyType substringWithRange:NSMakeRange(startIndex+1, endIndex-startIndex-1)];
    }
    return genericType;
}

#pragma mark 判断Class类型是否是JsonModel
BOOL genStringTypeIsGenModel(Class clazz)
{
    if ([clazz isSubclassOfClass:NSClassFromString(@"GenericModel")]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 判断字符串类型是否是NSArray
BOOL genStringTypeIsArray(NSString *type)
{
    if ([type rangeOfString:@"<"].location == NSNotFound) {
        if ([type rangeOfString:@"NSArray"].location != NSNotFound ||
            [type rangeOfString:@"NSMutableArray"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }else{
        NSUInteger endIndex = [type rangeOfString:@"<"].location;
        NSString *propertyType = [type substringWithRange:NSMakeRange(0, endIndex)];
        if ([propertyType rangeOfString:@"NSArray"].location != NSNotFound ||
            [propertyType rangeOfString:@"NSMutableArray"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark 判断对象是否是NSArray类型
BOOL genObjectTypeIsArray(id obj)
{
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 判断字符串是否是NSDictionary类型
BOOL genStringTypeIsDictionary(NSString *type)
{
    if ([type rangeOfString:@"<"].location == NSNotFound){
        if ([type rangeOfString:@"NSDictionary"].location != NSNotFound ||
            [type rangeOfString:@"NSMutableDictionary"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }else{
        NSUInteger endIndex = [type rangeOfString:@"<"].location;
        NSString *propertyType = [type substringWithRange:NSMakeRange(0, endIndex)];
        if ([propertyType rangeOfString:@"NSDictionary"].location != NSNotFound ||
            [propertyType rangeOfString:@"NSMutableDictionary"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark 判断对象是否是NSDictionary类型
BOOL genObjectTypeIsDictionary(id obj)
{
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 判断字符串是否是NSSset类型
BOOL genStringTypeIsSet(NSString *type)
{
    if ([type rangeOfString:@"<"].location == NSNotFound){
        if ([type rangeOfString:@"NSSet"].location != NSNotFound || [type rangeOfString:@"NSMutableSet"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }else{
        NSUInteger endIndex = [type rangeOfString:@"<"].location;
        NSString *propertyType = [type substringWithRange:NSMakeRange(0, endIndex)];
        if ([propertyType rangeOfString:@"NSSet"].location != NSNotFound ||
            [propertyType rangeOfString:@"NSMutableSet"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark 判断对象是否是NSSset类型
BOOL genObjectTypeIsSet(id obj)
{
    if ([obj isKindOfClass:[NSSet class]] || [obj isKindOfClass:[NSMutableSet class]]) {
        return YES;
    }else{
        return NO;
    }
}

@end
