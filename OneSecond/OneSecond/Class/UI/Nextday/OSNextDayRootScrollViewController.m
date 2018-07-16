//
//  OSNextDayRootScrollViewController.m
//  OneSecond
//
//  Created by 高守翰 on 2018/7/12.
//  Copyright © 2018 com.homeboy. All rights reserved.
//

#import "OSNextDayRootScrollViewController.h"
#import "OSNextDayViewController.h"
#import "OSDateUtil.h"

@interface OSNextDayRootScrollViewController ()

@property(nonatomic,strong) UIScrollView *OSNextDayScrollView; // 用来存储OSNextDayViewController的ScrollView

@property(nonatomic,strong) OSNextDayViewController *currentNextDayViewController; // 当前日期需要显示的图片
@property(nonatomic,strong) OSNextDayViewController *cachedNextDayViewController; //缓存需要显示的图片

@property(nonatomic,assign) NSInteger viewCount; // 计数器，用来调整ScorllView的大小

@property(nonatomic,copy) NSDate *currentDate; // 当前的日期
@property(nonatomic,copy) NSDate *cachedDate;// 所需下一天的日期

@property(nonatomic,copy) NSString *currentDateStr; // 当前的日期
@property(nonatomic,copy) NSString *cachedDateStr;// 所需下一天的日期




@end

@implementation OSNextDayRootScrollViewController

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
    // 初始化scrollview
    _viewCount = 2 ;
    _OSNextDayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_OSNextDayScrollView setContentSize:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT * _viewCount)];
    [_OSNextDayScrollView setPagingEnabled:YES];
    [_OSNextDayScrollView setBounces:NO];
    [_OSNextDayScrollView setShowsVerticalScrollIndicator:YES];
    
    // 设置delegate
    _OSNextDayScrollView.delegate = self;
    
    //这里和系统有关系
    if (@available(iOS 11.0, *)) {
        _OSNextDayScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:_OSNextDayScrollView];
    
    //设置日期
    _currentDate = [OSDateUtil getCurrentDate];
    _cachedDate = [OSDateUtil getPrevDateSince:_currentDate];
    
    _currentDateStr = [OSDateUtil getStringDate:_currentDate formatType:SIMPLEFORMATTYPE6];
    _cachedDateStr = [OSDateUtil getStringDate:_cachedDate formatType:SIMPLEFORMATTYPE6];

    
    // 初始化两个OSNextDayViewController
    _currentNextDayViewController = [[OSNextDayViewController alloc] init];
    _cachedNextDayViewController = [[OSNextDayViewController alloc] init];
    
    // 设置两个viewcontroller的inputDate
    _currentNextDayViewController.inputDate = _currentDate;
    _currentNextDayViewController.inputDateStr = _currentDateStr;
    _cachedNextDayViewController.inputDate = _cachedDate;
    _cachedNextDayViewController.inputDateStr = _cachedDateStr;

    
    //设置两个view在ScrollView中的位置
    CGRect currentFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    CGRect cachedFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    currentFrame.origin.y = 1 * currentFrame.size.height;
    cachedFrame.origin.y = 0 * cachedFrame.size.height;
    _currentNextDayViewController.view.frame = currentFrame;
    _cachedNextDayViewController.view.frame = cachedFrame;
    
    
    //添加到当前视图
    [self addChildViewController:_currentNextDayViewController];
    [self addChildViewController:_cachedNextDayViewController];
    [_OSNextDayScrollView addSubview:_currentNextDayViewController.view];
    [_OSNextDayScrollView addSubview:_cachedNextDayViewController.view];
    
    // 设置当前ScrollView显示的区域

    [_OSNextDayScrollView setContentOffset:CGPointMake(0, DEVICE_HEIGHT * 1)];

}


#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    // 下滑加载更早之前的

    if (_OSNextDayScrollView.contentOffset.y == 0) {
        
        // 交换两个viewcontroller
        _currentNextDayViewController = _cachedNextDayViewController;
        
        // 创建新的cachedViewController
        _cachedNextDayViewController = [[OSNextDayViewController alloc] init];
        
        //设置两个view在ScrollView中的位置
        CGRect currentFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        CGRect cachedFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        currentFrame.origin.y = 1 * currentFrame.size.height;
        cachedFrame.origin.y = 0 * cachedFrame.size.height;
        _currentNextDayViewController.view.frame = currentFrame;
        _cachedNextDayViewController.view.frame = cachedFrame;

        // 重新设置日期
        _currentDate = _cachedDate;
        _cachedDate = [OSDateUtil getPrevDateSince:_currentDate];

        _currentDateStr = [OSDateUtil getStringDate:_currentDate formatType:SIMPLEFORMATTYPE6];
        _cachedDateStr = [OSDateUtil getStringDate:_cachedDate formatType:SIMPLEFORMATTYPE6];
        
        _cachedNextDayViewController.inputDateStr = _cachedDateStr;
        _cachedNextDayViewController.inputDate = _cachedDate;
        
        //添加到当前视图

        [_OSNextDayScrollView addSubview:_currentNextDayViewController.view];
        [_OSNextDayScrollView addSubview:_cachedNextDayViewController.view];

        // 设置当前ScrollView显示的区域
        [_OSNextDayScrollView setContentOffset:CGPointMake(0, DEVICE_HEIGHT * 1)];
        
    } else {
        if (_currentDateStr == [OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6]) {
            NSLog(@"No more");
        } else {
            
            //交换两个viewcontroller
            _cachedNextDayViewController = _currentNextDayViewController;
            
            //创建新的currentViewController
            _currentNextDayViewController = [[OSNextDayViewController alloc] init];
            
            //设置两个view在ScrollView中的位置
            CGRect currentFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
            CGRect cachedFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
            currentFrame.origin.y = 1 * currentFrame.size.height;
            cachedFrame.origin.y = 0 * cachedFrame.size.height;
            _currentNextDayViewController.view.frame = currentFrame;
            _cachedNextDayViewController.view.frame = cachedFrame;
            
            // 重新设置日期
            _cachedDate = _currentDate;
            _currentDate = [OSDateUtil getNextDateSince:_currentDate];
            
            _cachedDateStr = [OSDateUtil getStringDate:_cachedDate formatType:SIMPLEFORMATTYPE6];
            _currentDateStr = [OSDateUtil getStringDate:_currentDate formatType:SIMPLEFORMATTYPE6];
            
            _currentNextDayViewController.inputDateStr = _currentDateStr;
            _currentNextDayViewController.inputDate = _currentDate;
            
            [_OSNextDayScrollView addSubview:_currentNextDayViewController.view];
            [_OSNextDayScrollView addSubview:_cachedNextDayViewController.view];
            
            // 设置当前ScrollView显示的区域
            
            [_OSNextDayScrollView setContentOffset:CGPointMake(0, DEVICE_HEIGHT * 1)];
        }
        

    }

   
}





@end

