//
//  OSRootBean.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSObject.h"

@interface OSRootBean : OSObject

/** set http request property */
- (void)bindValue:(id)value forKey:(NSString *)key;

- (void)bindStringValue:(NSString *)value forKey:(NSString *)key;

- (void)bindIntValue:(NSInteger)value forKey:(NSString *)key;

- (void)bindByteValue:(id)value forKey:(NSString *)key;

/** get http request propertyMap */
- (void)setProperty:(NSDictionary *)dic;

- (NSDictionary *)getProperty;

/** get http request propertyJSON */
//- (NSData *)getPropertyJSONData;

@end
