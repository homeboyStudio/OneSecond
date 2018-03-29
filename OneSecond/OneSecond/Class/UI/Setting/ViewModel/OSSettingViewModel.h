//
//  OSSettingViewModel.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/9.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OSSettingViewCells;

typedef NS_ENUM(NSUInteger, eSettingCellsSection) {
    eSettingFunctionSection,
    eSettingInformationSection
};

typedef NS_ENUM (NSUInteger, eSettingCellType) {
    eSettingClearCacheCell,
    eSettingSetTimeCell,
    eSettingFAQCell,
    eSettingFeedbackCell,
    eSettingRateCell,
    eSettingAboutCell,
    eSettingShareCell,
};

typedef void (^ClearCacheBlock) (NSString *detail);

@interface OSSettingViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, assign) double recoardTime;  // 录制时间

- (void)createTableData;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath;
- (OSSettingViewCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configCell:(OSSettingViewCells *)cell forRowIndexPath:(NSIndexPath *)indexPath;

// 接口API
// 清除缓存
- (void)ClearCacheWithBlock:(ClearCacheBlock)success;

@end
