//
//  OSFaqCells.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSTableViewCell.h"

@interface OSFaqCells : OSTableViewCell

@end


@interface OSFaqItemCell : OSFaqCells

@property (nonatomic, weak) IBOutlet UILabel *questionTitleLabel;
@property (nonatomic, weak) IBOutlet UITextView *questionDetailTextView;

- (void)setAttributeString:(NSString *)title detail:(NSString *)detail;

@end
