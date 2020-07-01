//
//  OSCalendarCellsModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCalendarCells.h"

@protocol OSCalendarcellsModelDelegate <NSObject>

@optional
- (void)gotoShowEventDayWithDateModel:(OSDateModel *)model;
- (void)gotoChangeBackgroundImageWithMonth:(NSString *)month;
- (void)gotoOpenLeftSideList;
- (void)gotoMovieClipAction;

@end

typedef NS_ENUM(NSUInteger, eCalendarCellsSection) {
    eCalendarItemsSection
};

typedef NS_ENUM(NSUInteger, eCalendarCellType) {
    eCalendarHeaderCell,
    eCalendarDateCell
};

@interface OSCalendarCellsModel : NSObject

@property (nonatomic, weak) id<OSCalendarcellsModelDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) OSCalendarModel *calendarModel;   // 所有事件的Model

- (void)createTableData;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath;

- (OSCalendarCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)configCell:(OSCalendarCells *)cell forRowIndexPath:(NSIndexPath *)indexPath;

- (void)setCellLabelAlpha:(CGFloat)degree;

@end
