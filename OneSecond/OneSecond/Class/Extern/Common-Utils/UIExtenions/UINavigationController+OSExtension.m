//
//  UINavigationController+OSExtension.m
//  OneSecond
//
//  Created by JHR on 15/10/21.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "UINavigationController+OSExtension.h"
#import <objc/runtime.h>


@implementation NSNumber (OSExtension)
- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}
@end

@interface UINavigationController(_OSExtension)
@property (nonatomic, copy) void (^_push_pop_Finished)(BOOL);
@property (nonatomic, assign) BOOL _navigationBarHidden;
@property (nonatomic, assign) CGFloat _navigationBarBackgroundReverseAlpha;
@end

@implementation UINavigationController (OSExtension)




#pragma mark - getters

- (CGFloat)navigationBarBackgroundAlpha {
    return [[self.navigationBar valueForKey:@"_backgroundView"] alpha];
}

- (BOOL)fullScreenInteractivePopGestureRecognizer {
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (CGFloat)_navigationBarBackgroundReverseAlpha {
    return [objc_getAssociatedObject(self, _cmd) CGFloatValue];
}

#pragma mark - setters

- (void)setFullScreenInteractivePopGestureRecognizer:(BOOL)fullScreenInteractivePopGestureRecognizer {
    if (fullScreenInteractivePopGestureRecognizer) {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIPanGestureRecognizer class]);
    } else {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIScreenEdgePanGestureRecognizer class]);
    }
}

- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha {
    [[self.navigationBar valueForKey:@"_backgroundView"] setAlpha:navigationBarBackgroundAlpha];
    // navigationBarBackgroundAlpha == 0 means hidden so do not set.
    if (!navigationBarBackgroundAlpha) return;
    self._navigationBarBackgroundReverseAlpha = 1-navigationBarBackgroundAlpha;
}

- (void)set_navigationBarBackgroundReverseAlpha:(CGFloat)_navigationBarBackgroundReverseAlpha {
    objc_setAssociatedObject(self, @selector(_navigationBarBackgroundReverseAlpha), @(_navigationBarBackgroundReverseAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
