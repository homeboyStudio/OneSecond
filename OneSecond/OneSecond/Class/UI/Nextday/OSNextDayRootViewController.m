//
//  OSNextDayRootScrollViewController.m
//  OneSecond
//
//  Created by 高守翰 on 2018/7/12.
//  Copyright © 2018 com.homeboy. All rights reserved.
//

#import "OSNextDayRootViewController.h"
#import "OSNextDayViewController.h"
#import "OSDateUtil.h"

@interface OSNextDayRootViewController () <UIGestureRecognizerDelegate>

@property(nonatomic,strong) OSNextDayViewController *firstNextDayViewController;
@property(nonatomic,strong) OSNextDayViewController *secondNextDayViewController;

@property(nonatomic,copy) NSDate *currentDate; // 当前的日期
@property(nonatomic,copy) NSDate *cachedDateTop;// 前一天的日期
@property(nonatomic,copy) NSDate *cachedDateBot;// 后一天的日期

@property(nonatomic,copy) NSString *currentDateStr; // 当前的日期
@property(nonatomic,copy) NSString *cachedDateStrTop;// 前一天的日期
@property(nonatomic,copy) NSString *cachedDateStrBot;// 后一天的日期

@property(nonatomic,assign) CGRect currentFrame; // 当前视图的位置
@property(nonatomic,assign) CGRect cachedFrameTop; // 上方缓存视图的位置
@property(nonatomic,assign) CGRect cachedFrameBot; // 下方缓存视图的位置



@property (nonatomic, strong) UIPanGestureRecognizer *swipeGR;


@end

@implementation OSNextDayRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self setupUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    //这里和系统有关系
    if (@available(iOS 11.0, *)) {
        //_OSNextDayRootScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //设置日期
    _currentDate = [OSDateUtil getCurrentDate];
    _cachedDateTop = [OSDateUtil getPrevDateSince:_currentDate];
    _cachedDateBot = [OSDateUtil getNextDateSince:_currentDate];
    
    _currentDateStr = [OSDateUtil getStringDate:_currentDate formatType:SIMPLEFORMATTYPE6];
    _cachedDateStrTop = [OSDateUtil getStringDate:_cachedDateTop formatType:SIMPLEFORMATTYPE6];
    _cachedDateStrBot = [OSDateUtil getStringDate:_cachedDateBot formatType:SIMPLEFORMATTYPE6];


    
    // 初始化两个OSNextDayViewController
    _firstNextDayViewController = [[OSNextDayViewController alloc] init];
    _secondNextDayViewController = [[OSNextDayViewController alloc] init];
    
    // 设置两个viewcontroller的inputDate
    _firstNextDayViewController.inputDate = _currentDate;
    _firstNextDayViewController.inputDateStr = _currentDateStr;
    
    _secondNextDayViewController.inputDate = _cachedDateTop;
    _secondNextDayViewController.inputDateStr = _cachedDateStrTop;

    
    //设置view的位置
    _currentFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    _cachedFrameTop = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    _cachedFrameBot = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    
    _currentFrame.origin.y = 0 * _currentFrame.size.height;
    _cachedFrameTop.origin.y = -1 * _cachedFrameTop.size.height;
    _cachedFrameBot.origin.y = 1 * _cachedFrameBot.size.height;
    
    _firstNextDayViewController.view.frame = _currentFrame;
    _secondNextDayViewController.view.frame = _cachedFrameTop;
    
    //添加到当前视图
    [self addChildViewController:_firstNextDayViewController];
    [self addChildViewController:_secondNextDayViewController];
    [self.view addSubview:_firstNextDayViewController.view];
    [self.view addSubview:_secondNextDayViewController.view];
    
    //添加手势
    _swipeGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    _swipeGR.delegate = self;
    [self.view addGestureRecognizer:_swipeGR];
    
    
}

#pragma ---------------- 手势相关 -----------------------

- (void)handleSwipe: (UIPanGestureRecognizer *) swipe {
    if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
    
    if (swipe.state == UIGestureRecognizerStateEnded) {
        [self gestureDidFinish:[swipe translationInView:self.view]];
    }

}

- (void)commitTranslation:(CGPoint)translation {
    
    // 获取横向纵向滑动距离
    CGFloat x = translation.x;
    CGFloat y = translation.y;
    
    //设置有效滑动距离
    CGFloat targetX = DEVICE_WIDTH / 5;
    CGFloat targetY = DEVICE_HEIGHT / 10;
    
    //向上向下活动逻辑
    if (y > targetY && fabs(x) < fabs(targetX)) {
        //准备View
        if (CGRectEqualToRect(_firstNextDayViewController.view.frame, _currentFrame)) {
            _secondNextDayViewController.inputDate = _cachedDateTop;
            _secondNextDayViewController.inputDateStr = _cachedDateStrTop;
            _secondNextDayViewController.view.frame = _cachedFrameTop;
            [_secondNextDayViewController updateUI];
            
        } else if (CGRectEqualToRect(_secondNextDayViewController.view.frame, _currentFrame)) {
            _firstNextDayViewController.inputDate = _cachedDateTop;
            _firstNextDayViewController.inputDateStr = _cachedDateStrTop;
            _firstNextDayViewController.view.frame = _cachedFrameTop;
            [_firstNextDayViewController updateUI];
        }
        
    } else if (y < -targetY && fabs(x) < fabs(targetY) && _currentDateStr != [OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6]) {
        
            if (CGRectEqualToRect(_firstNextDayViewController.view.frame, _currentFrame)) {
                _secondNextDayViewController.inputDate = _cachedDateBot;
                _secondNextDayViewController.inputDateStr = _cachedDateStrBot;
                _secondNextDayViewController.view.frame = _cachedFrameBot;
                [_secondNextDayViewController updateUI];
            
        } else if (CGRectEqualToRect(_secondNextDayViewController.view.frame, _currentFrame)) {
                _firstNextDayViewController.inputDate = _cachedDateBot;
                _firstNextDayViewController.inputDateStr = _cachedDateStrBot;
                _firstNextDayViewController.view.frame = _cachedFrameBot;
                [_firstNextDayViewController updateUI];
        }
        
    }
    
    
}

- (void)gestureDidFinish:(CGPoint)translation {
    // 获取横向纵向滑动距离
    CGFloat x = translation.x;
    CGFloat y = translation.y;
    
    //设置有效滑动距离
    CGFloat targetX = DEVICE_WIDTH / 5;
    CGFloat targetY = DEVICE_HEIGHT / 7;
    
     if (y > targetY && fabs(x) < fabs(targetX)) {
         //禁止滑动
         [_swipeGR  setEnabled:NO];
         
         //交换cachedView和currentView的位置
         [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             CGRect temp = _firstNextDayViewController.view.frame;
             _firstNextDayViewController.view.frame = _secondNextDayViewController.view.frame;
             _secondNextDayViewController.view.frame = temp;
             } completion:^(BOOL finished) {
                 //允许滑动
                 [_swipeGR setEnabled:YES];
                 //更新日期
                 [self updateTimeInfoWithDate:_cachedDateTop];

             }];
         
     } else if (y < -targetY && fabs(x) < fabs(targetY) && _currentDateStr != [OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6]) {
         [_swipeGR  setEnabled:NO];
         CGRect temp = _firstNextDayViewController.view.frame;
         [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             _firstNextDayViewController.view.frame = _secondNextDayViewController.view.frame;
             _secondNextDayViewController.view.frame = temp;
         } completion:^(BOOL finished) {
             //允许滑动
             [_swipeGR setEnabled:YES];
             //更新日期
             [self updateTimeInfoWithDate:_cachedDateBot];
         }];
     }
    
}

#pragma ---------------- 功能函数 -----------------------

- (void)updateTimeInfoWithDate:(NSDate *)date {
    _currentDate = date;
    _cachedDateTop = [OSDateUtil getPrevDateSince:_currentDate];
    _cachedDateBot = [OSDateUtil getNextDateSince:_currentDate];
    _currentDateStr = [OSDateUtil getStringDate:_currentDate formatType:SIMPLEFORMATTYPE6];
    _cachedDateStrTop = [OSDateUtil getStringDate:_cachedDateTop formatType:SIMPLEFORMATTYPE6];
    _cachedDateStrBot = [OSDateUtil getStringDate:_cachedDateBot formatType:SIMPLEFORMATTYPE6];
    
}

#pragma --------------- delegate -----------------------

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




@end

