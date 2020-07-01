//
//  OSAboutCells.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSTableViewCell.h"

@interface OSAboutCells : OSTableViewCell

@end


@interface OSAboutSpecialCell : OSAboutCells

@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *tedLabel;
@property (nonatomic, weak) IBOutlet UILabel *nextDayLabel;     
@property (nonatomic, weak) IBOutlet UILabel *thirdPartyLabel;  // 第三方库


@end


@interface OSAboutThirdPartyCell : OSAboutCells

@property (nonatomic, weak) IBOutlet UILabel *titlelabel;
@property (nonatomic, weak) IBOutlet UITextView *detailTextView;

@end

