//
//  OSLeftSideCellsModel.m
//  OneSecond
//
//  Created by JHR on 15/10/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSLeftSideCellsModel.h"
#import "OSLeftSideCells.h"

@interface OSLeftSideCellsModel()<OSLeftSideCellsDelegate>

@end

@implementation OSLeftSideCellsModel

#pragma mark --------- 初始化 ----------------
- (instancetype)init
{
    self = [super init];
    
    if (self) {
         _sectionArray = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark --------- 接口API -------------------------
- (void)createTableData
{
    if (_sectionArray == nil) {
        _sectionArray = [[NSMutableArray alloc] init];
        [_sectionArray addObject:[self addCellsToSection:eLeftSideItemsSection]];
    }else {
        [_sectionArray addObject:[self addCellsToSection:eLeftSideItemsSection]];
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.0f;
    eLeftSideCellType cellType = [self getCellType:indexPath];
    switch (cellType) {
        case eLeftSideHeaderCell:
        {
            if ([OSDevice isDeviceIPhone4s]) {
                height = 65.0f;
            }else if ([OSDevice isDeviceIPhone5]) {
                height = 90.0f;
            }else if ([OSDevice isDeviceIPhone6Plus]) {
                height = 120.0f;
            }else {
                height = 115.0f;
            }
            break;
        }
        case eLeftSideOneSecondCell:
        case eLeftSideCalendarCell:
        case eLeftSideNextDayCell:
        case eLeftSideSettingCell:
        {
            if ([OSDevice isDeviceIPhone4s]) {
                height = 52.0f;
            }else if ([OSDevice isDeviceIPhone5]) {
                height = 56.0f;
            }else if ([OSDevice isDeviceIPhone6Plus]) {
                height = 69.0f;
            }else {
                height = 63.0f;
            }
            break;
        }
        default:
            break;
    }
    return height;
}

- (NSString *)getIdentifierWithIndexPatch:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    eLeftSideCellType cellType = [self getCellType:indexPath];
    
    switch (cellType) {
        case eLeftSideHeaderCell:
        {
            identifier = @"OSLeftHeaderCell";
            break;
        }
        case eLeftSideOneSecondCell:
        {
            identifier = @"OSOneSecondCell";
            break;
        }
        case eLeftSideCalendarCell:
        {
            identifier = @"OSOneSecondCell";
            break;
        }
        case eLeftSideNextDayCell:
        {
            identifier = @"OSOneSecondCell";
            break;
        }
        case eLeftSideSettingCell:
        {
            identifier = @"OSOneSecondCell";
        }
        default:
        {
            break;
        }
    }
    return identifier;
}

- (OSLeftSideCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eLeftSideCellType cellType = [self getCellType:indexPath];
    switch (cellType) {
            case eLeftSideHeaderCell:
        {
            OSLeftHeaderCell *cell = (OSLeftHeaderCell *)[OSTableViewCell cellFromXib:@"OSLeftSideCells" atIndex:0];
            return cell;
            
            break;
        }
        case eLeftSideOneSecondCell:
        {
            OSOneSecondCell *cell = (OSOneSecondCell *)[OSTableViewCell cellFromXib:@"OSLeftSideCells" atIndex:1];
            cell.delegate = self;
//            [cell.leftImageView setImage:[UIImage imageNamed:@"leftside_btn_recording.png"]];
            [cell.itemButton setTitle:@"一秒" forState:UIControlStateNormal];
            [cell.itemButton setTag:100];
            return cell;
            break;
        }
        case eLeftSideCalendarCell:
        {
            OSOneSecondCell *cell = (OSOneSecondCell *)[OSTableViewCell cellFromXib:@"OSLeftSideCells" atIndex:1];
            cell.delegate = self;
//            [cell.leftImageView setImage:[UIImage imageNamed:@"leftside_btn_calendar.png"]];
            [cell.itemButton setTitle:@"日记" forState:UIControlStateNormal];
            [cell.itemButton setTag:200];
            return cell;

            break;
        }
        case eLeftSideNextDayCell:
        {
            OSOneSecondCell *cell = (OSOneSecondCell *)[OSTableViewCell cellFromXib:@"OSLeftSideCells" atIndex:1];
            cell.delegate = self;
//            [cell.leftImageView setImage:[UIImage imageNamed:@"leftside_btn_nd1.png"]];
            [cell.itemButton setTitle:@"世界" forState:UIControlStateNormal];
            [cell.itemButton setTag:300];
            return cell;
        }
        case eLeftSideSettingCell:
        {
            OSOneSecondCell *cell = (OSOneSecondCell *)[OSTableViewCell cellFromXib:@"OSLeftSideCells" atIndex:1];
            cell.delegate = self;
//            [cell.leftImageView setImage:[UIImage imageNamed:@"leftside_btn_setting.png"]];
            [cell.itemButton setTitle:@"设定" forState:UIControlStateNormal];
            [cell.itemButton setTag:400];
            return cell;
        }
        default:
        {
            return nil;
            break;
        }
    }
}

- (void)configCell:(OSLeftSideCells *)cell forRowIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -------- 功能函数 --------------------------

// 获得cell的类型
- (eLeftSideCellType)getCellType:(NSIndexPath *)indexPath
{
    //    section  ------ Section Dic --------- cells
    eLeftSideCellType type = 0;
    NSNumber *key = [[[self.sectionArray objectAtIndex:indexPath.section] allKeys] firstObject];
    NSArray *cells = [[self.sectionArray objectAtIndex:indexPath.section] objectForKey:key];
    NSNumber *cellType = [cells objectAtIndex:indexPath.row];
    type = cellType.integerValue;
    return type;
}

- (NSDictionary *)addCellsToSection:(eLeftSideCellsSection)sectionType
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    switch (sectionType) {
            
        case eLeftSideItemsSection:
        {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:@(eLeftSideHeaderCell)];
            [cells addObject:@(eLeftSideOneSecondCell)];
            [cells addObject:@(eLeftSideCalendarCell)];
            [cells addObject:@(eLeftSideNextDayCell)];
            [cells addObject:@(eLeftSideSettingCell)];
            [dic setObject:cells forKey:@(sectionType)];
            break;
        }
        default:
            break;
    }
    
    return dic;
}

#pragma mark -------- delegate -----------------

- (void)buttonClickItem:(NSInteger)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoChangeRootViewController:)]) {
        [self.delegate gotoChangeRootViewController:tag];
    }
}

@end
