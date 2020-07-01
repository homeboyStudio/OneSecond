//
//  OSLogger.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import "OSLogger.h"
#import "OSDateUtil.h"

static BOOL const  kDefaultMethodNameDisplay = YES;
static NSInteger currentLogLevel;

// Logging Descriptions
static NSString * const kOSLogLevelUndefined = @"Undefined";
static NSString * const kOSLogLevelVerbose = @"Verbose";
static NSString * const kOSLogLevelDebug = @"Debug";
static NSString * const kOSLogLevelInfo = @"Info";
static NSString * const kOSLogLevelWarn = @"Warn";
static NSString * const kOSLogLevelError = @"Error";

@implementation OSLogger

+ (BOOL)logLevel:(NSInteger) level file:(char*)sourceFile methodName:(NSString *) methodName lineNumber:(int)lineNumber format:(NSString*)format, ...; {
    BOOL success = NO;
    
#ifdef DEBUG_ENV
    currentLogLevel = 2; // debug
#else
    currentLogLevel = 5; // error
#endif
    
    if (level >= currentLogLevel) {
        va_list ap;
        va_start(ap,format);
        NSString * fileName = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
        NSString * printString = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        NSString * displayMethodName = (kDefaultMethodNameDisplay) ? methodName : @"";
        NSString * logString = [NSString stringWithFormat:@"\n【%@】[%s:%@:%d] %@: %@", [OSDateUtil getCurrentLogTime],[[fileName lastPathComponent] UTF8String],
                                displayMethodName, lineNumber, [[self class] logDescriptionBasedOnLogLevel:level], printString];
        success = [[self class] logOutputString:logString];
    }
    return success;
}

+ (BOOL)logOutputString:(NSString *) logString {
    NSLog(@"%@", logString);
    return YES;
}

+ (NSString *)logDescriptionBasedOnLogLevel:(OSLogLevel) level {
    NSString * description = kOSLogLevelUndefined;
    switch (level) {
        case OSLogLevelVerbose:
            description = kOSLogLevelVerbose;
            break;
        case OSLogLevelDebug:
            description = kOSLogLevelDebug;
            break;
        case OSLogLevelInfo:
            description = kOSLogLevelInfo;
            break;
        case OSLogLevelWarning:
            description = kOSLogLevelWarn;
            break;
        case OSLogLevelError:
            description = kOSLogLevelError;
            break;
        default:
            description = kOSLogLevelUndefined;
            break;
    }
    return description;
}


+ (NSString *)getURLByBaseUrl:(NSURL *)baseURL api:(NSString *)api params:(NSDictionary *)params{
    NSMutableString *result = [[NSMutableString alloc] init];
    if ([api hasPrefix:@"/"]) {
        api = [api substringFromIndex:1];
    }
    [result appendString:[NSString stringWithFormat:@"%@%@",baseURL.description,api]];
    
    
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in params)
    {
        NSString *encodedValue = [params valueForKey:key] ;
        NSString *part = [NSString stringWithFormat: @"%@=%@", key, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    [result appendString:[NSString stringWithFormat:@"?%@",encodedDictionary]];
    return result;
}

//+ (NSString *)getResuestJsonBody:(NSDictionary *)params{
//    NSString *result = @"";
//    result = [params JSONString];
//    return result;
//}

@end
