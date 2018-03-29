//
//  OSSettingViewModel.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/9.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSSettingViewModel.h"
#import "OSSettingViewCells.h"
#import "SDImageCache.h"
#import "OSFileUtil.h"

#define cellHeight ([OSDevice isDeviceIPhone4s] ? 40 : ([OSDevice isDeviceIPhone5] ? 40 : ([OSDevice isDeviceIPhone6] ? 45 : 50)))

@implementation OSSettingViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark --------------- 接口API -----------------------
- (void)createTableData
{
    [self.sectionArray addObject:[self addCellsToSection:eSettingFunctionSection]];
    [self.sectionArray addObject:[self addCellsToSection:eSettingInformationSection]];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eSettingCellType cellType = [self getCellType:indexPath];
    CGFloat height = cellHeight;
    
    switch (cellType) {
        case eSettingClearCacheCell:
        {
            break;
        }
            case eSettingSetTimeCell:
        {
            break;
        }
        case eSettingFAQCell:
        {
            break;
        }
        case eSettingFeedbackCell:
        {
            break;
        }
        case eSettingRateCell:
        {
            break;
        }
        case eSettingShareCell:
        {
            break;
        }
        case eSettingAboutCell:
        {
            break;
        }
        default:
            break;
    }
    
    return height;
}

- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"OSSettingClearCacheCell";
    eSettingCellType cellType = [self getCellType:indexPath];
    switch (cellType) {
        case eSettingClearCacheCell:
        {
            break;
        }
        case eSettingFAQCell:
        {
            break;
        }
        case eSettingFeedbackCell:
        {
            break;
        }
        case eSettingRateCell:
        {
            break;
        }
        case eSettingShareCell:
        {
            break;
        }
        case eSettingAboutCell:
        {
            break;
        }
        default:
            break;
    }
    return identifier;
}

- (OSSettingViewCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eSettingCellType cellType = [self getCellType:indexPath];
    switch (cellType) {
        case eSettingClearCacheCell:
        {
            OSSettingClearCacheCell *cell =  (OSSettingClearCacheCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:0];
            [cell.itemLabel setText:@"清理缓存"];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            return cell;
            
            break;
        }
            case eSettingSetTimeCell:
        {
            OSSettingSetTimeCell *cell = (OSSettingSetTimeCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:1];
            return cell;
            break;
        }
        case eSettingFAQCell:
        {
            OSSettingClearCacheCell *cell =  (OSSettingClearCacheCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:0];
            [cell.itemLabel setText:@"常见问题"];  // 帮助  操作指南
            return cell;

            break;
        }
        case eSettingFeedbackCell:
        {
            OSSettingClearCacheCell *cell =  (OSSettingClearCacheCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:0];
            [cell.itemLabel setText:@"意见和问题反馈"];
            return cell;

            break;
        }
        case eSettingRateCell:
        {
            OSSettingClearCacheCell *cell =  (OSSettingClearCacheCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:0];
            [cell.itemLabel setText:@"在 App Store 上评分"];  // 在AppStore上评分
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            return cell;

            break;
        }
        case eSettingShareCell:
        {
            OSSettingClearCacheCell *cell =  (OSSettingClearCacheCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:0];
            [cell.itemLabel setText:@"推荐给小伙伴"];
            return cell;

            break;
        }
        case eSettingAboutCell:
        {
            OSSettingClearCacheCell *cell =  (OSSettingClearCacheCell *)[OSTableViewCell cellFromXib:@"OSSettingViewCells" atIndex:0];
            [cell.itemLabel setText:@"关于"];
            return cell;

            break;
        }
        default:
            break;
    }
}

- (void)configCell:(OSSettingViewCells *)cell forRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            OSSettingSetTimeCell *timeCell = (OSSettingSetTimeCell *)cell;
            [timeCell.timeLabel setText:[NSString stringWithFormat:@"%.1f秒",self.recoardTime]];
        }
    }
}

#pragma mark --------------- 功能函数 ---------------------

- (eSettingCellType)getCellType:(NSIndexPath *)indexPath
{
    eSettingCellType type = 0;
    NSNumber *key = [[self.sectionArray[indexPath.section] allKeys] firstObject];
    NSArray *cells = [self.sectionArray[indexPath.section] objectForKey:key];
    NSNumber *cellType = [cells objectAtIndex:indexPath.row];
    type = cellType.integerValue;
    return type;
}

- (NSDictionary *)addCellsToSection:(eSettingCellsSection)sectionType
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    switch (sectionType) {
        case eSettingFunctionSection:
        {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:@(eSettingClearCacheCell)];
            [cells addObject:@(eSettingSetTimeCell)];
            [dic setObject:cells forKey:@(sectionType)];
            break;
        }
        case eSettingInformationSection:
        {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:@(eSettingRateCell)];
            [cells addObject:@(eSettingFAQCell)];
            [cells addObject:@(eSettingFeedbackCell)];
            [cells addObject:@(eSettingShareCell)];
            [cells addObject:@(eSettingAboutCell)];
            [dic setObject:cells forKey:@(sectionType)];
            break;
        }
        default:
            break;
    }
    return dic;
}

- (void)ClearCacheWithBlock:(ClearCacheBlock)success
{
    // 清除SDWebImageView
//    NSUInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
//    NSUInteger count = [[SDImageCache sharedImageCache] getDiskCount];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        // 清除Temp.mp4文件
        NSString *detail = @"已经清理干净啦，暂时没有缓存~";
        NSString *tempVideoPath = [OSFileUtil getFilePathStringWithDocument:@"temp.mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempVideoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:tempVideoPath error:nil];
            detail = @"缓存清除成功。";
        }
         NSString *clipVideoPath = [OSFileUtil getFilePathStringWithDocument:@"clip.mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:clipVideoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:clipVideoPath error:nil];
            detail = @"缓存清除成功。";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(detail);
        });
    });
    
}

@end
