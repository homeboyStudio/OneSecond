//
//  OSAboutCellsModel.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSAboutCellsModel.h"
#import "OSAboutCells.h"

#define cellHeight1 ([OSDevice isDeviceIPhone6Plus] ? 340.0f : ([OSDevice isDeviceIPhone6] ? 315.0f : ([OSDevice isDeviceIPhone5] ? 340.0f : 340.0f)))
#define cellHeight2 ([OSDevice isDeviceIPhone6Plus] ? 225.0f : ([OSDevice isDeviceIPhone6] ? 205.0f : ([OSDevice isDeviceIPhone5] ? 245.0f : 245.0f)))
#define cellHeight3 ([OSDevice isDeviceIPhone6Plus] ? 300.0f : ([OSDevice isDeviceIPhone6] ? 275.0f : ([OSDevice isDeviceIPhone5] ? 325.0f : 325.0f)))
#define cellHeight4 ([OSDevice isDeviceIPhone6Plus] ? 210.0f : ([OSDevice isDeviceIPhone6] ? 190.0f : ([OSDevice isDeviceIPhone5] ? 220.0f : 220.0f)))
#define cellHeight5 ([OSDevice isDeviceIPhone6Plus] ? 210.0f : ([OSDevice isDeviceIPhone6] ? 190.0f : ([OSDevice isDeviceIPhone5] ? 220.0f : 220.0f)))
#define cellHeight6 ([OSDevice isDeviceIPhone6Plus] ? 235.0f : ([OSDevice isDeviceIPhone6] ? 220.0f : ([OSDevice isDeviceIPhone5] ? 245.0f : 245.0f)))
#define cellHeight7 ([OSDevice isDeviceIPhone6Plus] ? 235.0f : ([OSDevice isDeviceIPhone6] ? 220.0f : ([OSDevice isDeviceIPhone5] ? 245.0f : 245.0f)))
#define cellHeight8 ([OSDevice isDeviceIPhone6Plus] ? 300.0f : ([OSDevice isDeviceIPhone6] ? 275.0f : ([OSDevice isDeviceIPhone5] ? 290.0f : 290.0f)))
  
@interface OSAboutCellsModel()

@end

@implementation OSAboutCellsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark ------------------ 接口API ---------------------------
- (void)createTableView
{
    [self.sectionArray addObject:[self addCellsToSection:eAboutItemsSection]];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eAboutCellType cellType = [self getCellType:indexPath];
    CGFloat height = 50.0f;
    switch (cellType) {
        case eAboutSpecialCell:
        {
            height = 200.0f;
            break;
        }
        case eAboutThirdPartyCell:
        {
            switch (indexPath.row) {
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
                case 6:
                {
                    height = cellHeight6;
                    break;
                }
                case 7:
                {
                    height = cellHeight7;
                    break;
                }
                case 8:
                {
                    height = cellHeight8;
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
    NSString *identifier = @"";
    eAboutCellType cellType = [self getCellType:indexPath];
    switch (cellType) {
        case eAboutSpecialCell:
        {
            identifier = @"OSAboutSpecialCell";
            break;
        }
        case eAboutThirdPartyCell:
        {
            identifier = @"OSAboutThirdPartyCell";
            break;
        }
        default:
            break;
    }
    return identifier;
}

- (OSAboutCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eAboutCellType cellType = [self getCellType:indexPath];
    
    switch (cellType) {
        case eAboutSpecialCell:
        {
            OSAboutSpecialCell *cell = (OSAboutSpecialCell *)[OSTableViewCell cellFromXib:@"OSAboutCells" atIndex:0];
            return cell;
            break;
        }
        case eAboutThirdPartyCell:
        {
            OSAboutThirdPartyCell *cell = (OSAboutThirdPartyCell *)[OSTableViewCell cellFromXib:@"OSAboutCells" atIndex:1];
            return cell;
            break;
        }
        default:
            break;
    }
}

- (void)configCell:(OSAboutCells *)cell forRowIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"FMDB"];
            [tpCell.detailTextView setText:@"If you are using FMDB in your project, I'd love to hear about it.  Let Gus know by sending an email to gus@flyingmeat.com.\n\nAnd if you happen to come across either Gus Mueller or Rob Ryan in a bar, you might consider purchasing a drink of their choosing if FMDB has been useful to you.\n\nFinally, and shortly, this is the MIT License.\n\nCopyright (c) 2008-2014 Flying Meat Inc.\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."];
            break;
        }
        case 2:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"AFNetworking"];
            [tpCell.detailTextView setText:@"Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/) \n\n Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: \n\n The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."];
            break;
        }
        case 3:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"GPUImage"];
            [tpCell.detailTextView setText:@"Copyright (c) 2012, Brad Larson, Ben Cochran, Hugues Lismonde, Keitaroh Kobayashi, Alaric Cole, Matthew Clark, Jacob Gundersen, Chris Williams.\nAll rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\nRedistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n\nRedistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\nNeither the name of the GPUImage framework nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission."];

            break;
        }
        case 4:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"SDWebImage"];
            [tpCell.detailTextView setText:@"Copyright (c) 2009 Olivier Poitrey <rs@dailymotion.com>\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."];
            
            break;
        }
        case 5:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"JTCalendar"];
            [tpCell.detailTextView setText:@"Copyright (c) 2015 Jonathan Tribouharet\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."];

            break;
        }
        case 6:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"LGSideMenuController"];
            [tpCell.detailTextView setText:@"The MIT License (MIT)\n\nCopyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."];

            break;
        }
        case 7:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"ZLSwipeableView"];
            [tpCell.detailTextView setText:@"The MIT License (MIT)\n\nCopyright (c) 2014\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."];
 
            break;
        }
        case 8:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@"FXBlurView"];
            [tpCell.detailTextView setText:@"Copyright (C) 2013 Charcoal Design\n\nThis software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.\n\nPermission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:\n\n1.The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.\n2.Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.\n3.This notice may not be removed or altered from any source distribution."];

            break;
        }
        case 9:
        {
            OSAboutThirdPartyCell *tpCell = (OSAboutThirdPartyCell *)cell;
            [tpCell.titlelabel setText:@""];
            [tpCell.detailTextView setText:@""];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark ------------------ 功能函数 ---------------------------

- (eAboutCellType)getCellType:(NSIndexPath *)indexPath
{
    eAboutCellType cellType = 0;
    NSNumber *key = [[[self.sectionArray objectAtIndex:indexPath.section] allKeys] firstObject];
    NSArray *cells = [[self.sectionArray objectAtIndex:indexPath.section] objectForKey:key];
    NSNumber *cell = [cells objectAtIndex:indexPath.row];
    cellType = cell.integerValue;
    return cellType;
}

- (NSDictionary *)addCellsToSection:(eAboutCellsSection)sectionType
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    switch (sectionType) {
        case eAboutItemsSection:
        {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:@(eAboutSpecialCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [cells addObject:@(eAboutThirdPartyCell)];
            [dic setObject:cells forKey:@(sectionType)];
            break;
        }
        default:
            break;
    }
    return dic;
}

@end
