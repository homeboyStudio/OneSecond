//
//  OSFaqCellsModel.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OSFaqCells;

typedef NS_ENUM(NSUInteger, eFaqCellsSection) {
    eFaqItemsSection
};

typedef NS_ENUM(NSUInteger, eFaqCellType) {
    eFaqItemCell
};
@interface OSFaqCellsModel : NSObject

@property (nonatomic, strong) NSMutableArray *sectionArray;

- (void)createTableView;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getIdentifierWithIndexPath:(NSIndexPath *)indexPath;
- (OSFaqCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configCell:(OSFaqCells *)cell forRowIndexPath:(NSIndexPath *)indexPath;

@end
