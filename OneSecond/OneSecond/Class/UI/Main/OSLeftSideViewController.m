//
//  OSLeftSideViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSLeftSideViewController.h"
#import "OSSideMenuController.h"
#import "OSCalendarViewController.h"
#import "OSNavigationController.h"
#import "OSRecordingViewController.h"
#import "OSNextDayViewController.h"
#import "OSSettingViewController.h"
#import "OSNextDayRootViewController.h"

@interface OSLeftSideViewController ()<UITableViewDelegate, OSReplayViewControllerDelegate>

@property (nonatomic, weak) IBOutlet OSTableView *leftTableView;
@property (nonatomic, strong) OSLeftSideCellsModel *infoViewModel;

@end

@implementation OSLeftSideViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.infoViewModel = [[OSLeftSideCellsModel alloc] init];
        self.infoViewModel.delegate = self;
//        delegate
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.leftTableView setBackgroundColor:[UIColor clearColor]];
    [self.infoViewModel createTableData];
}

#pragma mark ----------- 代理事件 ------------

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
    NSString *identifier = [self.infoViewModel getIdentifierWithIndexPatch:indexPath];
    OSLeftSideCells *cell = (OSLeftSideCells *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self.infoViewModel cellForRowAtIndexPath:indexPath];
    }
    [self.infoViewModel configCell:cell forRowIndexPath:indexPath];
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (indexPath.row) {
//        case 0:
//        {
//            break;
//        }
//        case 1:
//        {
//                    break;
//        }
//        case 2:
//        {
//            
//            break;
//        }
//        case 3:
//        {
//            
//            break;
//        }
//        case 4:
//        {
//            break;
//        }
//        default:
//            break;
//    }
}

- (void)gotoChangeRootViewController:(NSInteger)tag
{
    switch (tag) {
        case 100:    // 拍摄
        {
            OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            OSNavigationController *navigationCotroller = (OSNavigationController *)menuController.rootViewController;
            if (![navigationCotroller.topViewController isKindOfClass:[OSRecordingViewController class]]) {
                OSRecordingViewController *vc = [[OSRecordingViewController alloc] init];
                vc.delegate = self;
                OSNavigationController *nav = [[OSNavigationController alloc] initWithRootViewController:vc];
                
                //                nav.fullScreenInteractivePopGestureRecognizer =  NO;   // 是否允许全屏Pop手势
                [menuController setRootViewController:nav];
            }
            [menuController hideLeftViewAnimated:YES completionHandler:^{
                
            }];
            
            [menuController setRightViewSwipeGestureEnabled:NO];

            break;
        }
        case 200:    // 日记
        {
            OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            OSNavigationController *navigationCotroller = (OSNavigationController *)menuController.rootViewController;
            if (![navigationCotroller.topViewController isKindOfClass:[OSCalendarViewController class]]) {
                OSNavigationController *nav = [[OSNavigationController alloc] initWithRootViewController:[[OSCalendarViewController alloc] init]];
                
                //                nav.fullScreenInteractivePopGestureRecognizer = YES;   // 是否允许全屏Pop手势
                [menuController setRootViewController:nav];
            }
            [menuController hideLeftViewAnimated:YES completionHandler:^{
                
            }];
            
            [menuController setRightViewSwipeGestureEnabled:NO];

            break;
        }
        case 300:    // NextDay
        {
            OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            OSNavigationController *navigationCotroller = (OSNavigationController *)menuController.rootViewController;
            if (![navigationCotroller.topViewController isKindOfClass:[OSNextDayViewController class]]) {
                OSNavigationController *nav = [[OSNavigationController alloc] initWithRootViewController:[[OSNextDayRootViewController alloc] init]];
                [menuController setRootViewController:nav];
            }
            [menuController hideLeftViewAnimated:YES completionHandler:^{
                
            }];
            
            [menuController setRightViewSwipeGestureEnabled:YES];

            break;
        }
        case 400:   // 设置
        {
            OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            OSNavigationController *navigationCotroller = (OSNavigationController *)menuController.rootViewController;
            if (![navigationCotroller.topViewController isKindOfClass:[OSSettingViewController class]]) {
                OSNavigationController *nav = [[OSNavigationController alloc] initWithRootViewController:[[OSSettingViewController alloc] init]];
                [menuController setRootViewController:nav];
                
            }
            [menuController hideLeftViewAnimated:YES completionHandler:^{
                
            }];
            
            [menuController setRightViewSwipeGestureEnabled:NO];

            break;
        }
        default:
            break;
    }
}

- (void)changeToCalendarViewController:(OSCalendarViewController *)vc
{
    OSSideMenuController *menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [menuController showLeftViewAnimated:YES completionHandler:^{
        
        OSNavigationController *nav = [[OSNavigationController alloc] initWithRootViewController:vc];
        [menuController setRootViewController:nav];
        [menuController hideLeftViewAnimated:YES completionHandler:^{
        }];
        [menuController setRightViewSwipeGestureEnabled:NO];

    }];
}

#pragma mark ----------- 退出清空 ------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
