//
//  OSSettingViewCells.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/10.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSTableViewCell.h"

/*
 eSettingClearCacheCell,
 
 eSettingFAQCell,
 eSettingFeedbackCell,
 eSettingRateCell,
 eSettingAboutCell,
 eSettingShareCell,
 */

@interface OSSettingViewCells : OSTableViewCell

- (void)updateCellWithIndex:(NSIndexPath *)indexPath;

@end


@interface OSSettingClearCacheCell : OSSettingViewCells

@property (nonatomic, weak) IBOutlet UILabel *itemLabel;

@end

@interface OSSettingSetTimeCell : OSSettingViewCells

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@interface OSSettingFAQCell : OSSettingViewCells

@end


@interface OSSettingFeedbackCell : OSSettingViewCells

@end


@interface OSSettingRateCell : OSSettingViewCells

@end


@interface OSSettingAboutCell : OSSettingViewCells

@end


@interface OSSettingShareCell : OSSettingViewCells

@end