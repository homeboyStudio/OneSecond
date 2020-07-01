//
//  OSCalendarCells.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSTableViewCell.h"

@protocol OSCalendarCellDelegate <NSObject>

@optional

- (void)didSelectedEventDayWithDateModel:(OSDateModel *)model;
- (void)didSlideCalendarChangeWithDate:(NSDate *)date;
- (void)didClickBackHomeButtonAction;
- (void)didClickPlayMovieButtonAction;
- (void)didClickBackTodayButtonActionWithDate:(NSDate *)date;

@end


@interface OSCalendarModel : NSObject

@property (nonatomic, strong) NSDictionary *dateModelDic;  // 所有的事件的集合
@property (nonatomic, strong) NSArray *keysArray;          // 所有字典的keys集合
@property (nonatomic, strong) OSDateModel *dateModel;      // 所点击日期的对象

@end


@interface OSCalendarCells : OSTableViewCell

@property (nonatomic, weak) id<OSCalendarCellDelegate> delegate;

- (void)updateCell:(OSCalendarModel *)model index:(NSIndexPath *)indexPath;

@end

@interface OSCalendarHeaderCell : OSCalendarCells

- (void)updateDateWith:(NSString *)month;
- (void)setLabelAlpha:(CGFloat)degree;

@end

@interface OSCalendarDateCell : OSCalendarCells

@end

