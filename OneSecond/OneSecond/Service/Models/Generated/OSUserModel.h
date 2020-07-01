//
//  OSUserModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSObject.h"

@interface OSUserModel : OSObject

@end


@protocol OSGeoModel @end
@interface OSGeoModel : OSUserModel
@property (nonatomic, copy) NSString *reverse;
@end

@protocol OSAuthorModel @end
@interface OSAuthorModel : OSUserModel
@property (nonatomic, copy) NSString *name;
@end

@interface OSNextModel : OSUserModel

@property (nonatomic, copy) NSString *dateKey;
//@property (nonatomic, strong) NSMutableArray<OSGeoModel> *geo;
@property (nonatomic, strong) NSMutableDictionary<OSAuthorModel> *author;
@property (nonatomic, strong) NSMutableDictionary<OSGeoModel> *geo;

@end

//@protocol OSTextModel @end
//@interface OSTextModel : OSUserModel
//
//@property (nonatomic, copy) NSString *comment1;
//@property (nonatomic, copy) NSString *comment2;
//@property (nonatomic, copy) NSString *short;
//@property (nonatomic, copy) NSString *
//
//@end


