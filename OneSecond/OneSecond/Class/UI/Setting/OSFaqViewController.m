//
//  OSFaqViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/11.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSFaqViewController.h"
#import "OSFaqCellsModel.h"
#import "OSSideMenuController.h"

@interface OSFaqViewController ()

@property (nonatomic, weak) IBOutlet OSTableView *faqTableView;
@property (nonatomic, strong) OSFaqCellsModel *faqViewModel;

@property (nonatomic, weak) OSSideMenuController *menuController;

@end

@implementation OSFaqViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.faqViewModel = [[OSFaqCellsModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setCustomTitle:@"常见问题" withColor:[OSColor pureWhiteColor]];
    
    _menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [self.faqViewModel createTableView];
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

#pragma mark --------------- 代理方法 ---------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[[self.faqViewModel.sectionArray objectAtIndex:section] allKeys] firstObject];
    NSArray *cells = [[self.faqViewModel.sectionArray objectAtIndex:section] objectForKey:key];
    return [cells count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.faqViewModel.sectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.faqViewModel heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.faqViewModel getIdentifierWithIndexPath:indexPath];
    OSFaqCells *cell = (OSFaqCells *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self.faqViewModel cellForRowAtIndexPath:indexPath];
    }
    [self.faqViewModel configCell:cell forRowIndexPath:indexPath];
    return (UITableViewCell *)cell;
}

#pragma mark --------------- 退出清空 ---------------------

- (void)didReceiveMemoryWarning {
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
