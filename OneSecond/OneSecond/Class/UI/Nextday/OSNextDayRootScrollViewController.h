//
//  OSNextDayRootScrollViewController.h
//  OneSecond
//
//  Created by 高守翰 on 2018/7/12.
//  Copyright © 2018 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSNextDayRootScrollViewController <UIScrollViewDelegate>: UIViewController

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
