//
//  OSLeftSideCellsModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OSLeftSideCells;

typedef NS_ENUM(NSUInteger, eLeftSideCellsSection) {
    eLeftSideItemsSection
};

typedef NS_ENUM(NSUInteger, eLeftSideCellType) {
    eLeftSideHeaderCell,
    eLeftSideOneSecondCell,
    eLeftSideCalendarCell,
    eLeftSideNextDayCell,
    eLeftSideSettingCell
};

@protocol OSLeftSideCellsModelDelegate <NSObject>

- (void)gotoChangeRootViewController:(NSInteger)tag;

@end

@interface OSLeftSideCellsModel : NSObject

@property (nonatomic, weak) id<OSLeftSideCellsModelDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *sectionArray;

- (void)createTableData;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getIdentifierWithIndexPatch:(NSIndexPath *)indexPath;
- (OSLeftSideCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configCell:(OSLeftSideCells *)cell forRowIndexPath:(NSIndexPath *)indexPath;

@end
