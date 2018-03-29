//
//  OSLogger.h
//  OneSecond
//
//  Created by JunhuaRao on 16/3/8.
//  Copyright © 2016年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSConfig.h"

#ifdef DEBUG_ENV
#define VLog(s,...) [OSLogger logLevel:OSLogLevelVerbose file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define DLog(s,...) [OSLogger logLevel:OSLogLevelDebug file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define ILog(s,...) [OSLogger logLevel:OSLogLevelInfo file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define WLog(s,...) [OSLogger logLevel:OSLogLevelWarning file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define ELog(s,...) [OSLogger logLevel:OSLogLevelError file:__FILE__ methodName:NSStringFromSelector(_cmd) lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define CLog(format, ...) NSLog((@"%s@%d: " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define VLog(s,...)
#define DLog(s,...)
#define ILog(s,...)
#define WLog(s,...)
#define ELog(s,...)
#define CLog(format, ...)
#endif



typedef  NS_ENUM(NSInteger, OSLogLevel){
    OSLogLevelUndefined = 0,
    OSLogLevelVerbose,
    OSLogLevelDebug,
    OSLogLevelInfo,
    OSLogLevelWarning,
    OSLogLevelError
} ;

@interface OSLogger : NSObject

+(BOOL)logLevel:(NSInteger) level file:(char*)sourceFile methodName:(NSString *) methodName lineNumber:(int)lineNumber format:(NSString*)format, ...;

+(NSString *)getURLByBaseUrl:(NSURL *)baseURL api:(NSString *)api params:(NSDictionary *)params;

//+(NSString *)getResuestJsonBody:(NSDictionary *)params;

@end
