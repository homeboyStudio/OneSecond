//
//  OSPlayView.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/9.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSPlayView.h"
#import "ZLSwipeableView.h"
#import "OSPlayerView.h"
#import "OSCalendarCells.h"

@interface OSPlayView()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) BOOL loadCardFromXib;
@property (nonatomic, strong) ZLSwipeableView *swipeableView;
@property (nonatomic, assign) ZLSwipeableViewDirection direction;
@property (nonatomic, strong) OSCalendarModel *calendarModel;
@property (nonatomic, assign) NSInteger clickIndex;      // 所点击日期keys中的下标
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) OSPlayerView *player1;
@property (nonatomic, strong) OSPlayerView *player2;
@property (nonatomic, strong) OSPlayerView *player3;

//@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation OSPlayView

+ (OSPlayView *)showPlayViewWithOSCalendarModel:(OSCalendarModel *)calendarModel
{
    OSPlayView *view = [[OSPlayView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    view.calendarModel = calendarModel;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setupUI];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [self setupData];
}

- (void)setupData
{
    // 本日下标
    _clickIndex = (NSInteger)[_calendarModel.keysArray indexOfObject:_calendarModel.dateModel.date];
    _count = (NSInteger)[_calendarModel.keysArray count];
}

- (void)setupUI
{
    self.dynamic = NO;
    self.blurRadius = 8.0f;
    self.tintColor = [OSColor pureDarkColor];
    self.backgroundColor = [OSColor colorFromHex:@"#000000" alpha:0.5];
    
//    UIView *_backgroundView = [[UIView alloc] init];
//    [_backgroundView setBackgroundColor:[OSColor pureDarkColor]];
//    [_backgroundView setAlpha:0.2];
//    [_backgroundView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    [self addSubview:_backgroundView];
    
//    self addSubview:
//    self.tintColor = [UIColor blackColor];
    
    CGFloat width = DEVICE_WIDTH * 0.8;
    CGFloat height = (width*4)/3;
    _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH - width)/2, (DEVICE_HEIGHT - height)/2, width, height)];
    _swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal; // 只允许横向
    _swipeableView.numberOfActiveViews = 1;
//    [_swipeableView setUserInteractionEnabled:NO]; // 禁止相应传递者链
    [self addSubview:self.swipeableView];

    _player1 = [[OSPlayerView alloc] initWithFrame:_swipeableView.bounds];
    _player2 = [[OSPlayerView alloc] initWithFrame:_swipeableView.bounds];
    _player3 = [[OSPlayerView alloc] initWithFrame:_swipeableView.bounds];
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
//    tapGesture.cancelsTouchesInView = NO;
    [tapGesture setDelegate:self];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapView
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    animation.values = values;
    [_swipeableView.layer addAnimation:animation forKey:nil];
}
#pragma mark ------------ 代理方法 -----------------------

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction
{
    _direction = direction;
    swipeableView.panDirection = direction;
}

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
    OSPlayerView *view = nil;
    if (![_player1 superview]) {
        view = _player1;
    }else if(![_player2 superview]){
        view = _player2;
    }else {
        view = _player3;
    }
    
    if (_direction == ZLSwipeableViewDirectionLeft) {
        
        swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
        _clickIndex += 1;
        [view updatePlayerWith:[_calendarModel.dateModelDic objectForKey:_calendarModel.keysArray[_clickIndex]]];
        
        if ((_clickIndex + 1) == _count) {
            swipeableView.allowedDirection = ZLSwipeableViewDirectionRight;
        }
        return view;
        
    }else if (_direction == ZLSwipeableViewDirectionRight) {
        
        swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
        _clickIndex -= 1;
        [view updatePlayerWith:[_calendarModel.dateModelDic objectForKey:_calendarModel.keysArray[_clickIndex]]];
        
        if ((_clickIndex - 1) < 0) {
            swipeableView.allowedDirection = ZLSwipeableViewDirectionLeft;
        }
        return view;
        
           }else {
               if ([_calendarModel.keysArray count] == 1) {
                   swipeableView.allowedDirection = ZLSwipeableViewDirectionNone;
               }else if ((_clickIndex + 1) == _count) {
                   swipeableView.allowedDirection = ZLSwipeableViewDirectionRight;
               }else if ((_clickIndex - 1) < 0) {
                   swipeableView.allowedDirection = ZLSwipeableViewDirectionLeft;
               }
               // 当天
               [view updatePlayerWith:self.calendarModel.dateModel];
               return view;
           }
}

//- (void)layoutIfNeeded
//{
//    [self.swipeableView loadViewsIfNeeded];
//}

- (void)layoutSubviews
{
    [self.swipeableView loadViewsIfNeeded];
}

//- (UIView *)previousViewForSwipeableView:(ZLSwipeableView *)swipeableView
//{
//    UIView *view = [[UIView alloc] initWithFrame:swipeableView.bounds];
//    view.backgroundColor = [UIColor blackColor];
//    
//    return view;
//}

#pragma mark --------------------- API -------------------------
- (void)showAnimation
{
    self.alpha = 0;
  
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_swipeableView.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1.0;
    }];
}

#pragma mark ----------- gestureRecognizer delegate ------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[ZLSwipeableView class]] || [touch.view isKindOfClass:[OSPlayerView class]]) {
        return NO;
    }
    return YES;
}


@end
