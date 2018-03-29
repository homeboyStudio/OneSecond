//
//  OSLeftSideCells.h
//  OneSecond
//
//  Created by JHR on 15/10/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSTableViewCell.h"

@protocol OSLeftSideCellsDelegate <NSObject>

- (void)buttonClickItem:(NSInteger)tag;

@end

@interface OSLeftSideCells : OSTableViewCell

@property (nonatomic, weak) id<OSLeftSideCellsDelegate> delegate;

@end

@interface OSLeftHeaderCell : OSLeftSideCells

@end

@interface  OSOneSecondCell : OSLeftSideCells

@property (nonatomic, weak) IBOutlet UIImageView *leftImageView;  // 左边栏图片
@property (nonatomic, weak) IBOutlet UIButton *itemButton;        // 左边栏按钮

@end