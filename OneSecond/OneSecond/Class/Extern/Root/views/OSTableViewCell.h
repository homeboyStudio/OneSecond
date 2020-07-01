//
//  OSTableViewCell.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSTableViewCell : UITableViewCell

/**
 *  从XIB获取第index个对象cell
 *
 *  @param xibName xib名称
 *  @param index 对象索引
 */
+ (OSTableViewCell *)cellFromXib:(NSString *)xibName atIndex:(NSUInteger)index;

@end
