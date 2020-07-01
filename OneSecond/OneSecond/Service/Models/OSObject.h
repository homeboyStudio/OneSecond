//
//  OSObject.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "GenericModel.h"

@interface OSObject : GenericModel

@property (nonatomic, copy) NSString *session_token;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;

@end
