//
//  OSUserBean.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSRootBean.h"
#import "OSResponseModel.h"
#import "OSUserModel.h"

@interface OSUserBean : OSRootBean

#pragma mark - ------------ Request ----------------
@property (nonatomic, copy) NSString *dateString;

#pragma mark - ------------ Response Model ----------------

@property (nonatomic, strong) OSResponseModel *nextDayModel;
@property (nonatomic, strong) OSNextModel *logicNextDayModel;

@end
