//
//  OSTableViewCell.m
//  OneSecond
//
//  Created by JHR on 15/10/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSTableViewCell.h"

@implementation OSTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - --------------------接口API--------------------
#pragma mark 从XIB获取cell对象
+ (OSTableViewCell *)cellFromXib:(NSString *)xibName atIndex:(NSUInteger)index
{
    OSTableViewCell *cell = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    if (array.count > index) {
        cell = (OSTableViewCell *)[array objectAtIndex:index];
    }
    if (cell == nil) {
        cell = [[OSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return cell;
}

@end
