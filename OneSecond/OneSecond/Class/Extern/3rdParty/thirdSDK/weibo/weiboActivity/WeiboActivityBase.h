//
//  WeiboActivityBase.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/16.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboActivityBase : UIActivity {
    NSString *detailText;
    UIImage *image;
    NSURL *url;
}

@property (nonatomic, strong) UIImage *cutImage;

@end
