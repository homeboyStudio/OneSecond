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



@property (nonatomic, strong) UIPanGestureRecognizer *swipeGR; // 检测手势

@property (nonatomic, assign) BOOL updatedTop; //用来表示上方缓存视图是否准备好
@property (nonatomic, assign) BOOL updatedBot; //用来表示下方缓存视图是否准备好



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

    //flag 防止出现view出错 以及重复设置UI的情况
    _updatedTop = YES;
    _updatedBot = NO;
    
    //设置日期
    _currentDate = [OSDateUtil getCurrentDate];
    _cachedDateTop = [OSDateUtil getPrevDateSince:_currentDate];
    _cachedDateBot = [OSDateUtil getNextDateSince:_currentDate];
    
    //设置日期string
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
    
    //表示view是当前正在展示的view 还是缓存的view，1为当前正在显示，0为缓存的
    _firstNextDayViewController.status = 1;
    _secondNextDayViewController.status = 0;
    
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
    CGFloat targetY = DEVICE_HEIGHT / 20;
    
    //向上向下活动逻辑
    if (y > targetY && fabs(x) < fabs(targetX) && !_updatedTop) {
        
        //判断哪个视图是缓存视图
        if (_firstNextDayViewController.status == 1) {
            
            //准备缓存视图
            [self updateViewController:_secondNextDayViewController withDate:_cachedDateTop andDateStr:_cachedDateStrTop andFrame:_cachedFrameTop];
            
            //设置flag
            _updatedTop = YES;
            _updatedBot = NO;
            
            
        } else if (_secondNextDayViewController.status == 1) {
            
            //准备缓存视图
            [self updateViewController:_firstNextDayViewController withDate:_cachedDateTop andDateStr:_cachedDateStrTop andFrame:_cachedFrameTop];
            
            //设置flag
            _updatedTop = YES;
            _updatedBot = NO;
        }
        
    } else if (y < -targetY && fabs(x) < fabs(targetY) && _currentDateStr != [OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6] && !_updatedBot) {
        
            //判断哪个视图是缓存视图
        if (_firstNextDayViewController.status == 1) {
                
            //准备缓存视图
            [self updateViewController:_secondNextDayViewController withDate:_cachedDateBot andDateStr:_cachedDateStrBot andFrame:_cachedFrameBot];
                
            //设置flag
            _updatedTop = NO;
            _updatedBot = YES;
            
        } else if (_secondNextDayViewController.status == 1) {
            
            //准备缓存视图
            [self updateViewController:_firstNextDayViewController withDate:_cachedDateBot andDateStr:_cachedDateStrBot andFrame:_cachedFrameBot];
            
            //设置flag
            _updatedTop = NO;
            _updatedBot = YES;
        }
    }
    
    //设置上拉和下拉动画
    
    if (_updatedTop && y > 0) {
        
        CGFloat originalY = -DEVICE_HEIGHT;
        
        if (_firstNextDayViewController.view.frame.origin.y < 0) {
            
            [self moveView:_firstNextDayViewController verticallyUpOrDown:y withOriginalY:originalY];
            [self moveView:_secondNextDayViewController verticallyUpOrDown:y withOriginalY:0];
            
        } else if (_secondNextDayViewController.view.frame.origin.y < 0) {
            
            [self moveView:_secondNextDayViewController verticallyUpOrDown:y withOriginalY:originalY];
            [self moveView:_firstNextDayViewController verticallyUpOrDown:y withOriginalY:0];

        }
        
    } else if (_updatedBot && y < 0) {
        
        CGFloat originalY = DEVICE_HEIGHT;

        if (_firstNextDayViewController.view.frame.origin.y > 0) {
            
            [self moveView:_firstNextDayViewController verticallyUpOrDown:y withOriginalY:originalY];
            [self moveView:_secondNextDayViewController verticallyUpOrDown:y withOriginalY:0];

        } else if (_secondNextDayViewController.view.frame.origin.y > 0) {
            
            [self moveView:_secondNextDayViewController verticallyUpOrDown:y withOriginalY:originalY];
            [self moveView:_firstNextDayViewController verticallyUpOrDown:y withOriginalY:0];
            
        }
    }
    
}

- (void)gestureDidFinish:(CGPoint)translation {
    
    //获取横向纵向滑动距离
    CGFloat x = translation.x;
    CGFloat y = translation.y;
         //设置有效滑动距离
    CGFloat targetX = DEVICE_WIDTH / 5;
    CGFloat targetY = DEVICE_HEIGHT / 4;
    
    //判断是否是有效滑动
    if (y > targetY && fabs(x) < fabs(targetX) && _updatedTop) {
         
        //禁止滑动
        [_swipeGR  setEnabled:NO];
         
        //交换cachedView和currentView的位置
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            //重新设置位置和状态
            [self replaceView:_firstNextDayViewController andView:_secondNextDayViewController];
            
        } completion:^(BOOL finished) {
                 
            //允许滑动
            [_swipeGR setEnabled:YES];
                 
            //更新日期
            [self updateTimeInfoWithDate:_cachedDateTop];
                 
            //清空flag
            _updatedTop = NO;
            _updatedBot = NO;
        }];
         
    } else if (y < -targetY && fabs(x) < fabs(targetY) && _currentDateStr != [OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6] && _updatedBot) {
         
        //禁止滑动
        [_swipeGR  setEnabled:NO];
         
        //交换cachedView和currentView的位置
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            //重新设置位置和状态
            [self replaceView:_firstNextDayViewController andView:_secondNextDayViewController];


        } completion:^(BOOL finished) {
             
            //允许滑动
            [_swipeGR setEnabled:YES];
             
            //更新日期
            [self updateTimeInfoWithDate:_cachedDateBot];
             
            //清空flag
            _updatedTop = NO;
            _updatedBot = NO;
        }];
    }
    
   else {
      [self resetView:_firstNextDayViewController orView:_secondNextDayViewController];
   }
}

#pragma ---------------- 功能函数 -----------------------

//更新日期
- (void)updateTimeInfoWithDate:(NSDate *)date {
    _currentDate = date;
    _cachedDateTop = [OSDateUtil getPrevDateSince:_currentDate];
    _cachedDateBot = [OSDateUtil getNextDateSince:_currentDate];
    _currentDateStr = [OSDateUtil getStringDate:_currentDate formatType:SIMPLEFORMATTYPE6];
    _cachedDateStrTop = [OSDateUtil getStringDate:_cachedDateTop formatType:SIMPLEFORMATTYPE6];
    _cachedDateStrBot = [OSDateUtil getStringDate:_cachedDateBot formatType:SIMPLEFORMATTYPE6];
}

//更新UI
- (void)updateViewController: (OSNextDayViewController *)vc withDate: (NSDate *)date andDateStr: (NSString *)dateStr andFrame: (CGRect)frame {
    [vc cleanUpUI];
    vc.inputDate = date;
    vc.inputDateStr = dateStr;
    vc.view.frame = frame;
    [vc updateUI];
    
    //提升当前view的层级
    [self.view bringSubviewToFront:vc.view];
}

//重新位置和状态
- (void)replaceView: (OSNextDayViewController *)vc1 andView: (OSNextDayViewController *)vc2 {
    if (_updatedTop) {
        if (vc1.status == 1) {
            //交换status
            NSInteger temp = vc1.status;
            vc1.status = vc2.status;
            vc2.status = temp;
            
            [vc1.view setFrame:_cachedFrameTop];
            [vc2.view setFrame:_currentFrame];
            
        } else if (vc2.status == 1) {
            //交换status
            NSInteger temp = vc1.status;
            vc1.status = vc2.status;
            vc2.status = temp;
            
            [vc2.view setFrame:_cachedFrameTop];
            [vc1.view setFrame:_currentFrame];
        }
    } else if (_updatedBot) {
        if (vc1.status == 1) {
            //交换status
            NSInteger temp = vc1.status;
            vc1.status = vc2.status;
            vc2.status = temp;
            
            [vc1.view setFrame:_cachedFrameBot];
            [vc2.view setFrame:_currentFrame];
            
        } else if (vc2.status == 1) {
            //交换status
            NSInteger temp = vc1.status;
            vc1.status = vc2.status;
            vc2.status = temp;
            
            [vc2.view setFrame:_cachedFrameBot];
            [vc1.view setFrame:_currentFrame];
        }
        
    }
}

//跟随手势移动view
- (void)moveView: (OSNextDayViewController *)vc verticallyUpOrDown: (CGFloat) y withOriginalY: (CGFloat) orginalY{
    
    CGFloat newY = orginalY + y;
    
    [vc.view setFrame:CGRectMake(0, newY, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
}


//移动view到初始的位置
- (void)resetView: (OSNextDayViewController *)vc1 orView: (OSNextDayViewController *)vc2 {
    if (_updatedTop) {
        
        if (vc1.status == 0) {
            [vc1.view setFrame:_cachedFrameTop];
            [vc2.view setFrame:_currentFrame];
        } else if (vc2.status == 0) {
            [vc2.view setFrame:_cachedFrameTop];
            [vc1.view setFrame:_currentFrame];

        }
        
    } else if (_updatedBot) {
        
        if (vc1.status == 0) {
            [vc1.view setFrame:_cachedFrameBot];
            [vc2.view setFrame:_currentFrame];
        } else if (vc2.status == 0) {
            [vc2.view setFrame:_cachedFrameBot];
            [vc1.view setFrame:_currentFrame];
        }
        
    }
}

#pragma --------------- UIGestureRecognizer delegate -----------------------

//防止NavigationController的手势失效
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




@end

