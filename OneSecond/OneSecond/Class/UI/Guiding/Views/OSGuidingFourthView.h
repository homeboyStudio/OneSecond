//
//  OSGuidingFourthView.h
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSGuidingFourthViewDelegate <NSObject>

- (void)gotoMainViewController;

@end

@interface OSGuidingFourthView : UIView

@property (nonatomic, weak) id<OSGuidingFourthViewDelegate> delegate;

+ (instancetype)loadFromNib;

- (void)startAnimation;

@end
