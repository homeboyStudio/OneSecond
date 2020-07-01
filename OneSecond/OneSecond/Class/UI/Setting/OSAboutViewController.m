//
//  OSAboutViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSAboutViewController.h"
#import "OSAboutCellsModel.h"
#import "OSSideMenuController.h"

@interface OSAboutViewController ()

@property (nonatomic, weak) IBOutlet OSTableView *aboutTableVew;
@property (nonatomic, strong) OSAboutCellsModel *aboutCellModel;

@property (nonatomic, weak) OSSideMenuController *menuController;

@end

@implementation OSAboutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.aboutCellModel = [[OSAboutCellsModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCustomTitle:@"关于" withColor:[OSColor pureWhiteColor]];
    
    _menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [self.aboutCellModel createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_menuController setLeftViewSwipeGestureEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_menuController setLeftViewSwipeGestureEnabled:YES];
}

#pragma mark ----------------- 代理事件 -----------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[[self.aboutCellModel.sectionArray objectAtIndex:section] allKeys] firstObject];
    NSArray *cells = [[self.aboutCellModel.sectionArray objectAtIndex:section] objectForKey:key];
    return [cells count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.aboutCellModel.sectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.aboutCellModel heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.aboutCellModel getIdentifierWithIndexPath:indexPath];
    OSAboutCells *cell = (OSAboutCells *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self.aboutCellModel cellForRowAtIndexPath:indexPath];
    }
    [self.aboutCellModel configCell:cell forRowIndexPath:indexPath];
    return (UITableViewCell *)cell;
}

#pragma mark ----------------- 功能函数 -----------------------------


#pragma mark ----------------- 退出清空 -----------------------------
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
