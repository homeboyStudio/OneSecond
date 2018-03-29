//
//  OSGuidingFourthView.h
//  OneSecond
//
//  Created by JunhuaRao on 15/12/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
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
