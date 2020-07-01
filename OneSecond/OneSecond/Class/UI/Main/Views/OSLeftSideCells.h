//
//  OSLeftSideCells.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
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
