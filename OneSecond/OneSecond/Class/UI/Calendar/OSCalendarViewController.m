//
//  OSCalendarViewController.m
//  OneSecond
//
//  Created by JHR on 15/10/19.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSCalendarViewController.h"
#import "AppDelegate.h"
#import "OSCalendarCellsModel.h"
#import "DBDateUtils.h"
#import "UIImage+OSColor.h"
#import "OSPlayView.h"
#import "OSDateUtil.h"
#import "OSSideMenuController.h"
#import "OSMovieClipViewController.h"
#import "OSVideoClipViewController.h"
#import "SIAlertView.h"

#define offsetLayoutHeight ([OSDevice isDeviceIPhone4s] ? 60 : ([OSDevice isDeviceIPhone5] ? 40 : ([OSDevice isDeviceIPhone6] ? 40 : 40)))
#define offsetImageViewHeight ([OSDevice isDeviceIPhone4s] ? 240.0f : ([OSDevice isDeviceIPhone5] ? 240.0f : ([OSDevice isDeviceIPhone6] ? 281.0f : 310.5f)))

@interface OSCalendarViewController ()<OSCalendarcellsModelDelegate, UITableViewDataSource, UITableViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) OSCalendarCellsModel *infoViewModel;
@property (nonatomic, weak) IBOutlet OSTableView *calendarTableView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
//@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) FXBlurView *blurImage;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bgImageViewConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bgImageViewHeightConstraint;

//@property (nonatomic, assign) CGFloat layoutHeight;
//@property (nonatomic, assign) CGFloat imageViewHeight;

@property (nonatomic , strong) UIImage *gotoNextImage;

@end

@implementation OSCalendarViewController

#pragma mark - --------------------System--------------------
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.infoViewModel = [[OSCalendarCellsModel alloc] init];
        self.infoViewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.infoViewModel createTableData];
    
    [self.osNavigationController setNavigationBarHidden:YES];
    
    NSString *nowDate = [OSDateUtil getMonthStringWithDate:[OSDateUtil getCurrentTime]];
    UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",nowDate]];
 
    [_backgroundImageView setImage:image];
    
//    _frontImageView = [[UIImageView alloc] initWithImage:blurredImage];
//    _frontImageView.hidden = YES;
//    [_frontImageView setFrame:CGRectMake(0, -30.0f, DEVICE_WIDTH, DEVICE_WIDTH)];
//    [self.view insertSubview:_frontImageView aboveSubview:_backgroundImageView];
//    _frontImageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    _blurImage = [[FXBlurView alloc] init];
//    [_blurImage setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    _blurImage.dynamic = YES;
//    _blurImage.tintColor = [UIColor clearColor];
//    _blurImage.blurRadius = 8.0f;
//    
//    [self.view insertSubview:_blurImage aboveSubview:_backgroundImageView];
    
    
    
    if ([OSDevice isDeviceIPhone4s]) {
        self.bgImageViewConstraint.constant =  - offsetLayoutHeight;
        self.bgImageViewHeightConstraint.constant = offsetImageViewHeight;

    }else if ([OSDevice isDeviceIPhone5]) {
        self.bgImageViewConstraint.constant =  - offsetLayoutHeight;
        self.bgImageViewHeightConstraint.constant = offsetImageViewHeight;

    }else if ([OSDevice isDeviceIPhone6]) {
        self.bgImageViewConstraint.constant =  - offsetLayoutHeight;
        self.bgImageViewHeightConstraint.constant = offsetImageViewHeight;
    }else {
        self.bgImageViewConstraint.constant =  - offsetLayoutHeight;
        self.bgImageViewHeightConstraint.constant = offsetImageViewHeight;
    }
    
    //防止iOS 11 出现头顶20像素空白
    if (@available(iOS 11.0, *)) {
        _calendarTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    // 子线程加载数据
    [self getAllDateModelFromDateBase];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - --------------------功能函数--------------------
#pragma mark 初始化

- (void)getAllDateModelFromDateBase
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 获得数据库中所有的事件
        OSCalendarModel *model = [[OSCalendarModel alloc] init];
        model.dateModelDic = [DBDateUtils getAllDateModelDictionaryFromDateBase];
        // 获得所有的Keys（升序）
        model.keysArray = [[model.dateModelDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        self.infoViewModel.calendarModel = model;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.calendarTableView reloadData];
        });
        
    });
}

#pragma mark - --------------------手势事件--------------------
#pragma mark 各种手势处理函数注释

#pragma mark - --------------------按钮事件--------------------
#pragma mark 按钮点击函数注释

#pragma mark - --------------------代理方法--------------------
#pragma mark - 代理种类注释
#pragma mark 代理函数注释

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[[self.infoViewModel.sectionArray objectAtIndex:section] allKeys] firstObject];
    NSArray *cells = [[self.infoViewModel.sectionArray objectAtIndex:section] objectForKey:key];
    return [cells count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.infoViewModel.sectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.infoViewModel heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.infoViewModel getIdentifierWithIndexPath:indexPath];
    OSCalendarCells *cell = (OSCalendarCells *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self.infoViewModel cellForRowAtIndexPath:indexPath];
    }
    [self.infoViewModel configCell:cell forRowIndexPath:indexPath];
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - OSCalendarCellsModel delegate
- (void)gotoShowEventDayWithDateModel:(OSDateModel *)model
{
    self.infoViewModel.calendarModel.dateModel = model;
    OSPlayView *view = [OSPlayView showPlayViewWithOSCalendarModel:self.infoViewModel.calendarModel];
    [self.view addSubview:view];
    [view showAnimation];
}

- (void)gotoChangeBackgroundImageWithMonth:(NSString *)month
{
    // 切换背景动画
    _gotoNextImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",month]];
//    [_backgroundImageView setImage:_gotoNextImage];
    
    // 切换动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.fromValue = _backgroundImageView.layer.contents;
    animation.toValue = (__bridge id _Nullable)(_gotoNextImage.CGImage);
    animation.duration = .5f;
    animation.delegate = self;
    // 设置动画结束后的内容
    _backgroundImageView.layer.contents = (__bridge id _Nullable)(_gotoNextImage.CGImage);
    [_backgroundImageView.layer addAnimation:animation forKey:nil];
//        UIImage *blurImage =  [_blurFilter imageByFilteringImage:originalImage];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_backgroundImageView setImage:_gotoNextImage];
}

- (void)gotoOpenLeftSideList
{
    OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [menuController showLeftViewAnimated:YES completionHandler:^{
    
    }];
}

- (void)gotoMovieClipAction
{
    NSUInteger count = [DBDateUtils countOfDateModelWithDateBase];
    if (count != 0) {
//        OSMovieClipViewController *movieClipViewController = [[OSMovieClipViewController alloc] init];
//        [self.osNavigationController pushViewController:movieClipViewController animated:YES];
        
        OSVideoClipViewController *nextPageVC = [[OSVideoClipViewController alloc] init];
        [self.osNavigationController pushViewController:nextPageVC animated:YES];
    }else {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"还没有记录过任何一天，开始记录您的第一秒吧O(∩_∩)O~~"];
        [alertView addButtonWithTitle:@"好的"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        
        //        [alertView addButtonWithTitle:@"取消"
        //                                 type:SIAlertViewButtonTypeCancel
        //                              handler:^(SIAlertView *alertView) {
        //
        //                              }];
        
        alertView.enabledParallaxEffect = NO;
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
    }
}

#pragma mark - scrollerView delegate
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//   CGPoint point = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat y = point.y;
    
    // 100    0 alpha = 1     -100 alpha = 0
    if (y >= 0) {
//    [_frontImageView setAlpha:1.0f];
        [_blurImage setAlpha:1.0f];
        [_infoViewModel setCellLabelAlpha:1.0F];
        return;
    }
    
    CGFloat offsety = y + 100;
//    CGRect frame  = _backgroundImageView.frame;
    
    CGFloat imageY = -y - offsetLayoutHeight;
    // Y
    if (imageY >= 0) {
        //  放大，但是Y轴保持不变
        CGFloat zoomSize = imageY;
        
        self.bgImageViewHeightConstraint.constant = offsetImageViewHeight + zoomSize;
//        frame.size.height = DEVICE_WIDTH  + zoomSize;
        
        imageY = 0;
    }
    
    // 改变Y轴坐标
//    frame.origin.y = imageY;

//    _frontImageView.frame = frame;
//    _backgroundImageView.frame = frame;
    
    self.bgImageViewConstraint.constant = imageY;
    
    [_blurImage setAlpha:offsety/100.0f];
    [_infoViewModel setCellLabelAlpha:offsety/100.0f];
    
//    [_frontImageView setAlpha:offsety/100.0f];
}

#pragma mark - --------------------属性相关--------------------
#pragma mark 属性操作函数注释

#pragma mark - --------------------接口API--------------------
#pragma mark 分块内接口函数注释


#pragma mark ---------- 退出清空 --------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
