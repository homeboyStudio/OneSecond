//
//  WeiboActivityBase.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboActivityBase : UIActivity {
    NSString *detailText;
    UIImage *image;
    NSURL *url;
}

@property (nonatomic, strong) UIImage *cutImage;

@end
