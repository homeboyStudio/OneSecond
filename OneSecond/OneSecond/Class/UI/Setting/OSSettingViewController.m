//
//  OSSettingViewController.m
//  OneSecond
//
//  Created by JunhuaRao on 15/12/8.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSSettingViewController.h"
#import "OSSettingViewModel.h"
#import "OSAboutViewController.h"
#import "OSFaqViewController.h"
#import "OSSideMenuController.h"
#import "OSShareView.h"
#import "SIAlertView.h"
#import <MessageUI/MessageUI.h>

@interface OSSettingViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) OSSettingViewModel *settingViewModel;

@property (nonatomic, weak) IBOutlet OSTableView *tableView;
@property (nonatomic, weak) OSSideMenuController *menuController;

@property (nonatomic, weak) IBOutlet UIImageView *heartImageView;
@property (nonatomic, weak) IBOutlet UILabel *withLabel;
@property (nonatomic, weak) IBOutlet UILabel *inLabel;

@end

@implementation OSSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.settingViewModel = [[OSSettingViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCustomTitle:@"设定" withColor:[OSColor pureWhiteColor]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"btn_home_white.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_home_white.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(openLeftSideButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self setLeftBarButtonItem:leftBarButtonItem];
    _menuController = (OSSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;

    [_tableView setBackgroundColor:[OSColor colorFromHex:@"F4F4F4" alpha:1.0]];
    [self.view setBackgroundColor:[OSColor colorFromHex:@"F4F4F4" alpha:1.0]];
    
    CGFloat fontSize = AuxiliaryFontSize;
    if ([OSDevice isDeviceIPhone4s]) {
        fontSize = AuxiliaryFontSize - 2;
    }else if ([OSDevice isDeviceIPhone5]) {
        fontSize = AuxiliaryFontSize - 2;
    }else if ([OSDevice isDeviceIPhone6Plus]) {
//        fontSize = AuxiliaryFontSize
    }else {
        fontSize = AuxiliaryFontSize - 1;
    }
    
    [_withLabel setFont:[OSFont nextDayFontWithSize:fontSize]];
    [_withLabel setTextColor:[OSColor loveColor]];
    [_inLabel setFont:[OSFont nextDayFontWithSize:fontSize]];
    [_inLabel setTextColor:[OSColor loveColor]];
//    [_inLabel setTextColor:[OSColor colorFromHex:@"C8C1B9" alpha:1.0]];
    
    // 读取录制时间
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    double time = [userDefault doubleForKey:@"recordtime"];
    if (time) {
        self.settingViewModel.recoardTime = time;
    }else {
        self.settingViewModel.recoardTime = 1.0;
    }

    [self.settingViewModel createTableData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark --------------- 代理事件 ---------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[[self.settingViewModel.sectionArray objectAtIndex:section] allKeys] firstObject];
    NSArray *cells = [[self.settingViewModel.sectionArray objectAtIndex:section] objectForKey:key];
    return [cells count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settingViewModel.sectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[OSColor specialGaryColor]];
    [label setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    [label setFrame:CGRectMake(15, 15, DEVICE_WIDTH, 20)];
    if (section == 0) {
        [label setText:@"功能"];
    }else {
        [label setText:@"信息"];
    }
    [headerView addSubview:label];
    return headerView;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] init];
//    [headerView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
//    [headerView setBackgroundColor:[OSColor specialorangColor]];
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.settingViewModel heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.settingViewModel getIdentifierWithIndexPath:indexPath];
    OSSettingViewCells *cell = (OSSettingViewCells *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self.settingViewModel cellForRowAtIndexPath:indexPath];
    }
    [self.settingViewModel configCell:cell forRowIndexPath:indexPath];
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:hud];
                    //        hud.color = [UIColor clearColor];
                    AMTumblrHud *tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.view.frame.size.width - 55) * 0.5),
                                                                                           (CGFloat) ((self.view.frame.size.height - 20) * 0.5), 55, 20)];
                    tumblrHUD.hudColor = [OSColor specialGaryColor];
                    [tumblrHUD showAnimated:YES];
                    hud.labelText = @"正在清理";
                    [hud setLabelFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
                    [hud setLabelColor:[OSColor pureDarkColor]];
                    [hud setColor:[OSColor pureWhiteColor]];
                    hud.customView = tumblrHUD;
                    hud.mode = MBProgressHUDModeCustomView;
                    [hud show:YES];
                    // 清理缓存
                    [_settingViewModel ClearCacheWithBlock:^(NSString *detail){
                        // main
                        [hud hide:YES];
                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:detail];
                        [alertView addButtonWithTitle:@"确定"
                                                 type:SIAlertViewButtonTypeDefault
                                              handler:^(SIAlertView *alertView) {
                                                  
                                              }];
                        
                        alertView.enabledParallaxEffect = NO;
                        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                        [alertView show];
                    }];
                    
                    break;
                }
                case 1: {
                      [[[UIAlertView alloc] initWithTitle:@"变更录制时间" message:@"建议选择更短录制时间以减少存储空间，日常记录请使用1.0秒录制时间。" delegate:self cancelButtonTitle:@"8.0秒" otherButtonTitles:@"1.0秒",@"2.0秒",@"3.0秒",@"5.0秒",nil] show];
                    // 选择器
                    break;
                }
                default:
                    break;
            }
            break;
        }
            case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    // 评分
//                    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1069756461" ];
//                    
//                    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
//                        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1069756461"];
//                    }
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1069756461"]];
                    break;
                }
                case 1:
                {
                    // 常见问题
                    OSFaqViewController *faqViewController = [[OSFaqViewController alloc] init];
                    [self.osNavigationController pushViewController:faqViewController animated:YES];
                    break;
                }
                case 2:
                {
                    // 意见反馈
                    [self sendEmailToFeedback];
                    break;
                }
                case 3:
                {
                    // 分享给好友
                    [OSShareView showSocialSharePanelWith:self shareContext:nil];
                    break;
                }
                case 4:
                {
                    // 关于
                    OSAboutViewController *aboutViewController = [[OSAboutViewController alloc] init];
                    [self.osNavigationController pushViewController:aboutViewController animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 0:
        {
            self.settingViewModel.recoardTime = 8.0;
            [userDefault setDouble:8.0 forKey:@"recordtime"];
            // 10sec
            break;
        }
        case 1:
        {
            self.settingViewModel.recoardTime = 1.0;
            [userDefault setDouble:1.0 forKey:@"recordtime"];
            // 1sec
            break;
        }
        case 2:
        {
             self.settingViewModel.recoardTime = 2.0;
            [userDefault setDouble:2.0 forKey:@"recordtime"];
            // 2sec
            break;
        }
        case 3:
        {
             self.settingViewModel.recoardTime = 3.0;
             [userDefault setDouble:3.0 forKey:@"recordtime"];
            // 3sec
            break;
        }
        case 4:
        {
            self.settingViewModel.recoardTime = 5.0;
            [userDefault setDouble:5.0 forKey:@"recordtime"];
            // 5sec
            break;
        }
        default:
        {
            self.settingViewModel.recoardTime = 1.00;
            [userDefault setDouble:1.00 forKey:@"recordtime"];
            break;
        }
    }
    [userDefault synchronize];
    [self.tableView reloadData];
}

#pragma mark --------------- 功能函数 ---------------------------s
-(void)sendEmailToFeedback
{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        
        if ([MFMailComposeViewController canSendMail]) {
            [self displayComposerSheet];
        }else {
            [self gotoOutsideTheApptoSendEmail];
        }
    }
}

- (void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    // 设置主题
    [mailPicker setSubject:@"一秒 - 意见和问题反馈"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject:@"homeboy0119@gmail.com"];
    [mailPicker setToRecipients:toRecipients];
    
    
//    Device Information:
//Device: iPhone7,1
//    iOS Version: 9.2
//Language: zh-Hans-CN (中文（简体、中国）)
//Carrier: 中国联通
//Timezone: GMT+8
//Architecture: N/A
    
    NSString *appName = [NSString stringWithFormat:@"App Name:  %@",[OSDevice appName]];
    NSString *appVersion = [NSString stringWithFormat:@"App Version:  %@",[OSDevice appVersionAndBuild]];

    NSString *device = [NSString stringWithFormat:@"Device:  %@",[OSDevice deviceString]];
    NSString *iosVersion = [NSString stringWithFormat:@"iOS Version:  %@",[[UIDevice currentDevice] systemVersion]];
    
    NSString *networkStatus;
    switch (__dataSource.networkType) {
        case eNetworkType_Cellular:
        {
            networkStatus = @"Cellular";
            break;
        }
        case eNetworkType_WIFI:
        {
            networkStatus = @"WiFi";
            break;
        }
        case eNetworkType_None:
        {
            networkStatus = @"None";
            break;
        }
        default:
            break;
    }
    NSString *connectionStatus = [NSString stringWithFormat:@"Connection Status:%@",networkStatus];
    
    NSString *text = [NSString stringWithFormat:@"请写下您的反馈信息或问题描述，我会尽快查看并且回复您：<br/><br/><br/><br/><br/>App Information:<br/>%@<br/>%@<br/><br/>Device Information:<br/>%@<br/>%@<br/>%@",appName,appVersion,device,iosVersion,connectionStatus];
    
    NSString *emailBody = text;
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:mailPicker animated:YES completion:^{
        
    }];
}

- (void)gotoOutsideTheApptoSendEmail
{
    NSMutableString *mailUrl = [[NSMutableString alloc] init];

    [mailUrl appendFormat:@"mailto:homeboy0119@gmail.com?cc=&bcc="];
    
    [mailUrl appendString:@"&subject=一秒 - 意见和问题反馈"];
    
    
    NSString *appName = [NSString stringWithFormat:@"App Name:%@",[OSDevice appName]];
    NSString *appVersion = [NSString stringWithFormat:@"App Version:  %@",[OSDevice appVersionAndBuild]];
    
    NSString *device = [NSString stringWithFormat:@"Device:  %@",[OSDevice deviceString]];
    NSString *iosVersion = [NSString stringWithFormat:@"iOS Version:  %@",[[UIDevice currentDevice] systemVersion]];
    
    NSString *networkStatus;
    switch (__dataSource.networkType) {
        case eNetworkType_Cellular:
        {
            networkStatus = @"Cellular";
            break;
        }
        case eNetworkType_WIFI:
        {
            networkStatus = @"WiFi";
            break;
        }
        case eNetworkType_None:
        {
            networkStatus = @"None";
            break;
        }
        default:
            break;
    }
    
    NSString *connectionStatus = [NSString stringWithFormat:@"Connection Status:  %@",networkStatus];
    
    NSString *text = [NSString stringWithFormat:@"&body=请写下您的反馈信息或问题描述，我会尽快查看并且回复您：<br/><br/><br/><br/><br/>App Information:<br/>%@<br/>%@<br/><br/>Device Information:<br/>%@<br/>%@<br/>%@",appName,appVersion,device,iosVersion,connectionStatus];
    
    [mailUrl appendString:text];
    
     NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        //        hud.color = [UIColor clearColor];
        hud.labelText = msg;
        [hud setLabelFont:[OSFont nextDayFontWithSize:ExplanatoryFontSize]];
        [hud setLabelColor:[OSColor pureWhiteColor]];
        [hud setColor:[OSColor colorFromHex:@"000000" alpha:0.6]];
        hud.mode = MBProgressHUDModeCustomView;
        [hud show:YES];
        [hud hide:YES afterDelay:.5];
    }];
}



#pragma mark --------------- 按钮事件 ---------------------------
- (void)openLeftSideButtonAction
{
    [_menuController showLeftViewAnimated:YES completionHandler:^{
        
    }];
}

#pragma mark --------------- 退出清空 ---------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
