//
//  OSCalendarCellsModel.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/2.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSCalendarCellsModel.h"
#import "OSCalendarCells.h"
#import "OSDateUtil.h"

#define cellHederHeight ([OSDevice isDeviceIPhone4s] ? 180.0f : ([OSDevice isDeviceIPhone5] ? 200.0f : ([OSDevice isDeviceIPhone6] ? 241.0f : 270.5f)))
#define cellCalendarHeight ([OSDevice isDeviceIPhone4s] ? 300.0f : ([OSDevice isDeviceIPhone5] ? 368.0f : ([OSDevice isDeviceIPhone6] ? 425.0f : 450.0f)))

@interface OSCalendarCellsModel()<OSCalendarCellDelegate>

@property (nonatomic, strong) OSCalendarHeaderCell *headerCell;

@end

@implementation OSCalendarCellsModel

#pragma mark --------------- 初始化 ----------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createTableData
{
    if (_sectionArray == nil) {
        _sectionArray = [[NSMutableArray alloc] init];
    }else {
        // 添加section
        [_sectionArray addObject:[self addCellsToSection:eCalendarItemsSection]];
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch ([self getCellType:indexPath]) {
        case eCalendarHeaderCell:
        {
            height = cellHederHeight;
            break;
        }
            case eCalendarDateCell:
        {
            height = cellCalendarHeight;
            break;
        }
        default:
            break;
    }
    return height;
}

- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch ([self getCellType:indexPath]) {
        case eCalendarHeaderCell:
        {
            identifier = @"OSCalendarHeaderCell";
            break;
        }
        case eCalendarDateCell:
        {
            identifier = @"OSCalendarDateCell";
            break;
        }
        default:
            break;
    }
    return identifier;
}

- (OSCalendarCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self getCellType:indexPath]) {
        case eCalendarHeaderCell:
        {
            OSCalendarHeaderCell *cell = (OSCalendarHeaderCell *)[OSTableViewCell cellFromXib:@"OSCalendarCells" atIndex:0];
            _headerCell = cell;
            cell.delegate = self;
            return cell;
            break;
        }
        case eCalendarDateCell:
        {
            OSCalendarDateCell *cell = (OSCalendarDateCell *)[OSTableViewCell cellFromXib:@"OSCalendarCells" atIndex:1];
            cell.delegate = self;
            return cell;
            break;
        }
        default:
            break;
    }
    
}

- (void)configCell:(OSCalendarCells *)cell forRowIndexPath:(NSIndexPath *)indexPath
{
    // 暂时不分类
    if (self.calendarModel != nil) {
        [cell updateCell:self.calendarModel index:indexPath];
    }
}

#pragma mark ----------- 功能函数 -------------------

// 获得cell类型
- (eCalendarCellType)getCellType:(NSIndexPath *)indexPath
{
    eCalendarCellType type = 0;
    NSNumber *key = [[[_sectionArray objectAtIndex:indexPath.section] allKeys] firstObject];
    NSArray *cells = [[_sectionArray objectAtIndex:indexPath.section] objectForKey:key];
    NSNumber *cellType = [cells objectAtIndex:indexPath.row];
    type = cellType.integerValue;
    return type;
}

- (NSDictionary *)addCellsToSection:(eCalendarCellsSection)sectionType
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    switch (sectionType) {
        case eCalendarItemsSection:
        {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:@(eCalendarHeaderCell)];
            [cells addObject:@(eCalendarDateCell)];
            [dic setObject:cells forKey:@(sectionType)];
            break;
        }
        default:
            break;
    }
    return dic;
}

- (void)setCellLabelAlpha:(CGFloat)degree
{
    [_headerCell setLabelAlpha:degree];
}

#pragma mark --------- 代理事件 -------------------------

- (void)didClickBackHomeButtonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoOpenLeftSideList)]) {
        [self.delegate gotoOpenLeftSideList];
    }
}

- (void)didClickPlayMovieButtonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoMovieClipAction)]) {
        [self.delegate gotoMovieClipAction];
    }
}

- (void)didSelectedEventDayWithDateModel:(OSDateModel *)model
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoShowEventDayWithDateModel:)]) {
        [self.delegate gotoShowEventDayWithDateModel:model];
    }
}

- (void)didSlideCalendarChangeWithDate:(NSDate *)date
{
    NSString *dateString = [OSDateUtil getStringDate:date formatType:SIMPLEFORMATTYPE6];
    NSString *month = [OSDateUtil getMonthStringWithDate:dateString];
    // 更新日期 并且更新图片
    [_headerCell updateDateWith:[OSDateUtil getMonthAndYearStringWithDate:dateString]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoChangeBackgroundImageWithMonth:)]) {
        [self.delegate gotoChangeBackgroundImageWithMonth:month];
    }
}

- (void)didClickBackTodayButtonActionWithDate:(NSDate *)date
{
    NSString *dateString = [OSDateUtil getStringDate:date formatType:SIMPLEFORMATTYPE6];
    NSString *month = [OSDateUtil getMonthStringWithDate:dateString];
    // 更新日期 并且更新图片
    [_headerCell updateDateWith:[OSDateUtil getMonthAndYearStringWithDate:dateString]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoChangeBackgroundImageWithMonth:)]) {
        [self.delegate gotoChangeBackgroundImageWithMonth:month];
    }
}

@end
