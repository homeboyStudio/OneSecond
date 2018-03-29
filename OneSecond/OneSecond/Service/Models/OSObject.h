//
//  OSObject.h
//  OneSecond
//
//  Created by JunhuaRao on 15/11/20.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "GenericModel.h"

@interface OSObject : GenericModel

@property (nonatomic, copy) NSString *session_token;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;

@end
