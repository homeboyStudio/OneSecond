//
//  OSNextDayRootScrollViewController.m
//  OneSecond
//
//  Created by 高守翰 on 2018/7/12.
//  Copyright © 2018 com.homeboy. All rights reserved.
//

#import "OSNextDayRootScrollViewController.h"
#import "OSNextDayViewController.h"
@interface OSNextDayRootScrollViewController ()

@property(nonatomic,strong) UIScrollView *OSNextDayScrollView;
@property(nonatomic,strong) OSNextDayViewController *currentNextDayViewController;
@property(nonatomic,strong) OSNextDayViewController *nextNextDayViewController;
@property(nonatomic,strong) OSNextDayViewController *prevNextDayViewController;
@property(nonatomic,assign) NSInteger viewCount;

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
    
    // 初始化三个OSNextDayViewController，一个作为当前显示的，另一个作为将要被滑动显示出来的，还有一个作为之前的
    _prevNextDayViewController = [[OSNextDayViewController alloc] init];
    _currentNextDayViewController = [[OSNextDayViewController alloc] init];
    _nextNextDayViewController = [[OSNextDayViewController alloc] init];

    
    //设置两个view在ScrollView中的位置
    CGRect nextFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    CGRect currentFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    CGRect prevFrame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    nextFrame.origin.y = 0 * nextFrame.size.height;
    currentFrame.origin.y = 1 * currentFrame.size.height;
    prevFrame.origin.y = 2 * prevFrame.size.height;
    _currentNextDayViewController.view.frame = currentFrame;
    _nextNextDayViewController.view.frame = nextFrame;
    _prevNextDayViewController.view.frame = prevFrame;
    
    //添加到当前视图
    [self addChildViewController:_currentNextDayViewController];
    [self addChildViewController:_nextNextDayViewController];
    [self addChildViewController:_prevNextDayViewController];
    [_OSNextDayScrollView addSubview:_currentNextDayViewController.view];
    [_OSNextDayScrollView addSubview:_nextNextDayViewController.view];
    [_OSNextDayScrollView addSubview:_prevNextDayViewController.view];

    
    // 设置当前ScrollView显示的区域
    [_OSNextDayScrollView setContentOffset:CGPointMake(0, DEVICE_HEIGHT * 1)];
    
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //下滑加载更早之前的
    
    if (_OSNextDayScrollView.contentOffset.y <= 0) {
        
        // 重新设置ScrollView的尺寸
        _viewCount = 3;
        [_OSNextDayScrollView setContentSize:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT * _viewCount)];
        
        // 交换各个ViewController的内容
        _prevNextDayViewController = _currentNextDayViewController;
        _currentNextDayViewController = _nextNextDayViewController;
        _nextNextDayViewController = [[OSNextDayViewController alloc] init];
        
        // 设置当前ScrollView显示的区域
        [_OSNextDayScrollView setContentOffset:CGPointMake(0, DEVICE_HEIGHT * 1)];
    }
    
    //上滑加载之后的
    if (_OSNextDayScrollView.contentOffset.y > 0) {
        if (_viewCount == 2) {
            NSLog(@"没有更多了");
        }
        else {

            // 交换各个ViewController的内容
            _nextNextDayViewController = _currentNextDayViewController;
            _currentNextDayViewController = _prevNextDayViewController;
            _prevNextDayViewController = [[OSNextDayViewController alloc] init];

            //这里还要加入锅是最后一天的逻辑


            // 设置当前ScrollView显示的区域
            [_OSNextDayScrollView setContentOffset:CGPointMake(0, DEVICE_HEIGHT * 1)];
        }
    }
}



@end

