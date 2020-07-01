//
//  OSResponseModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSObject.h"

@interface OSResponseModel : OSObject

/** 不需要框架解析，自己解析 */
@property (nonatomic, strong) NSMutableDictionary *resultJsonModel;

@end
