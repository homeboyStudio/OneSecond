//
//  OSFaqCellsModel.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSFaqCellsModel.h"
#import "OSFaqCells.h"

#define cellHeight0 ([OSDevice isDeviceIPhone6Plus] ? 145.0f : ([OSDevice isDeviceIPhone6] ? 140.0f : ([OSDevice isDeviceIPhone5] ? 185.0f : 185.0f)))
#define cellHeight1 ([OSDevice isDeviceIPhone6Plus] ? 170.0f : ([OSDevice isDeviceIPhone6] ? 160.0f : ([OSDevice isDeviceIPhone5] ? 181.0f : 181.0f)))
#define cellHeight2 ([OSDevice isDeviceIPhone6Plus] ? 120.0f : ([OSDevice isDeviceIPhone6] ? 115.0f : ([OSDevice isDeviceIPhone5] ? 115.0f : 115.0f)))
#define cellHeight3 ([OSDevice isDeviceIPhone6Plus] ? 120.0f : ([OSDevice isDeviceIPhone6] ? 115.0f : ([OSDevice isDeviceIPhone5] ? 115.0f : 115.0f)))
#define cellHeight4 ([OSDevice isDeviceIPhone6Plus] ? 125.0f : ([OSDevice isDeviceIPhone6] ? 118.0f : ([OSDevice isDeviceIPhone5] ? 137.0f : 137.0f)))
#define cellHeight5 ([OSDevice isDeviceIPhone6Plus] ? 240.0f : ([OSDevice isDeviceIPhone6] ? 230.0f : ([OSDevice isDeviceIPhone5] ? 250.0f : 250.0f)))

@implementation OSFaqCellsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark ------------------- 接口API ------------------------
- (void)createTableView
{
    [self.sectionArray addObject:[self addCellsToSection:eFaqItemsSection]];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eFaqCellType cellType = [self getCellType:indexPath];
    CGFloat height = 0.0f;
    switch (cellType) {
        case eFaqItemCell:
        {
            switch (indexPath.row) {
                case 0:
                {
                    height = cellHeight0;
                    break;
                }
                case 1:
                {
                    height = cellHeight1;
                    break;
                }
                case 2:
                {
                    height = cellHeight2;
                    break;
                }
                case 3:
                {
                    height = cellHeight3;
                    break;
                }
                case 4:
                {
                    height = cellHeight4;
                    break;
                }
                    case 5:
                {
                    height = cellHeight5;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    return height;
}

- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    eFaqCellType cellType = [self getCellType:indexPath];
    NSString *identifier = @"";
    switch (cellType) {
        case eFaqItemCell:
        {
            identifier = @"OSFaqItemCell";
            break;
        }
        default:
            break;
    }
    return identifier;
}

- (OSFaqCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eFaqCellType cellType = [self getCellType:indexPath];
    switch (cellType) {
        case eFaqItemCell:
        {
            OSFaqItemCell *cell = (OSFaqItemCell *)[OSTableViewCell cellFromXib:@"OSFaqCells" atIndex:0];
            return cell;
            break;
        }
        default:
            break;
    }
}

- (void)configCell:(OSFaqCells *)cell forRowIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"有哪些需要注意的事项?" detail:@"1.请允许“一秒”访问相机和麦克风权限,拒绝其中之一将导致无法录制视频,请在系统设置-隐私中修改。\n2.如果您想删除本应用,请先到“日记”中保存视频到本地之后在进行删除操作,以免造成视频数据的丢失。"];
            break;
        }
        case 1:
        {
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"如何将视频导出? 如何分享视频?" detail:@"1.请允许“一秒”访问照片的权限,在“日记”中点击精彩故事,点击保存按钮等待渲染完成后就可以导出到本地照片当中;\n2.需要分享视频的用户,请先将视频保存到本地,然后可以上传到其他的视频分享类应用中进行分享。"];
            break;
        }
        case 2:
        {
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"每天拍摄视频保存在哪里?" detail:@"每天拍摄的视频会存储在手机内存中,请放心一秒每天拍摄的视频所占空间非常小,您也可以定期在设定当中清除缓存。"];
            break;
        }
        case 3:
        {
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"某天忘记拍了,可以补拍吗?当天可以重拍吗?" detail:@"1.暂不支持补拍,记住以后要每天坚持记录哦;\n2.当天可以重拍,直接拍摄完成后点保存就可以覆盖当天之前拍摄的片段了。"];
            break;
        }
        case 4:
        {
//            -我们希望将人们的过去现在将来连接在一起
//            -让人们习惯去记录
//            -习惯去把每一天过得精彩
//            -让人们多一种生活方式
//            -建立一个永久的回忆库
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"为什么一天只能拍摄一小段视频?" detail:@"当然在某些特别的时刻您也可以在\"设定\"中更改录制时间,每一天都是特别珍贵的,希望短短的一秒,就能触发你一整天的回忆,将时间慢慢的汇集成一分钟、一小时..."];
            //////////////////////////////////////////////////////////////
            break;
        }
        case 5:
        {
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"关于一秒,为什么要做这样的应用?" detail:@"一秒的制作灵感来自于TED演讲《每天一秒钟》,为了实现其演讲者的想法,才有了这款应用的诞生,应用不参与商业用途并且所有的功能免费,由于是空闲时间做出来的产品,如有需要改进的地方希望大家能给出反馈,开发者将为用户提供更好记录时间的体验。\n联系我们&意见反馈：\n邮箱：homeboy0119@gmail.com\n微博：@一秒App"];
            break;
        }
        case 6:
        {
            OSFaqItemCell *faqCell = (OSFaqItemCell *)cell;
            [faqCell setAttributeString:@"" detail:@""];
            break;
        }
        default:
            break;
    }
}

#pragma mark ------------------- 功能函数 -------------------------
- (eFaqCellType)getCellType:(NSIndexPath *)indexPath
{
    eFaqCellType cellType = 0;
    NSNumber *key = [[[self.sectionArray objectAtIndex:indexPath.section] allKeys] firstObject];
    NSArray *cells = [[self.sectionArray objectAtIndex:indexPath.section] objectForKey:key];
    NSNumber *cell = [cells objectAtIndex:indexPath.row];
    cellType = cell.integerValue;
    return cellType;
}

- (NSDictionary *)addCellsToSection:(eFaqCellsSection)sectionType
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    switch (sectionType) {
        case eFaqItemsSection:
        {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:@(eFaqItemCell)];
            [cells addObject:@(eFaqItemCell)];
            [cells addObject:@(eFaqItemCell)];
            [cells addObject:@(eFaqItemCell)];
            [cells addObject:@(eFaqItemCell)];
            [cells addObject:@(eFaqItemCell)];
            [dic setObject:cells forKey:@(sectionType)];
            break;
        }
        default:
            break;
    }
    return dic;
}

@end
