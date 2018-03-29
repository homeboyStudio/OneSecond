//
//  OSAboutCellsModel.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/10.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OSAboutCells;

typedef NS_ENUM(NSUInteger, eAboutCellsSection) {
    eAboutItemsSection
};

typedef NS_ENUM(NSUInteger, eAboutCellType) {
    eAboutSpecialCell,
    eAboutThirdPartyCell
};

@interface OSAboutCellsModel : NSObject

@property (nonatomic, strong) NSMutableArray *sectionArray;

- (void)createTableView;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath;
- (OSAboutCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configCell:(OSAboutCells *)cell forRowIndexPath:(NSIndexPath *)indexPath;

@end
