//
//  AppDelegate.m
//  OneSecond
//
//  Created by JHR on 15/10/11.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "AppDelegate.h"
#import "OSNavigationController.h"
#import "OSSideMenuController.h"
#import "NetworkUtil.h"
#import "OSLeftSideViewController.h"
#import "OSRecordingViewController.h"
#import "NSString+Check.h"
#import "DBDateUtils.h"
#import "OSCalendarViewController.h"
#import "OSServiceConfigManager.h"
#import "DBDateUtils.h"
#import "OSDateUtil.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "OSGuidingViewController.h"
#import "OSNextDayViewController.h"

static NSString *DATABASE_NAME = @"OneSecond.db";

#define weixinAppKey @"wxdeb90b5e9bacf4cb"
#define weiboAppKey  @"3745506074"

@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate>

@property (nonatomic, strong) NetworkUtil *networkUtil;   //  监测网络状态

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 1.初始化数据库
    [self initDataBase];
    // 2.初始化__dataSource
    initDataSource();
    // 3.注册通知
    [self registerNotification];
    // 4.开启网络监测
    [self startDetectNetwork];
    // 5.开启定位服务
    
//   NSString *identifier = [[UIDevice currentDevice].identifierForVendor UUIDString];
//   NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    // 6.配置SDK
    [self configThirdPartySDK];
   
    // 7.配置RootView
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 8.判断是否是新用户第一次注册
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"FirstLoad"] == nil) {
        OSGuidingViewController *vc = [[OSGuidingViewController alloc] initWithNibName:@"OSGuidingViewController" bundle:nil];
        self.window.rootViewController = vc;
    }else {
        // test guiding view
//        OSGuidingViewController *vc = [[OSGuidingViewController alloc] initWithNibName:@"OSGuidingViewController" bundle:nil];
//        self.window.rootViewController = vc;
        // 这里判断今日日记是否已经拍摄来判断设置RootViewController
        OSNavigationController *nav = nil;
        if ([DBDateUtils existDateModelWithDataBase:[OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6]]) {
            nav = [[OSNavigationController alloc] initWithRootViewController:[[OSCalendarViewController alloc] init]];
            OSSideMenuController *sideMenuController = [[OSSideMenuController alloc] initWithRootViewController:nav];
            [sideMenuController setRightViewSwipeGestureEnabled:NO];
            self.window.rootViewController = sideMenuController;
        }else {
            OSRecordingViewController *vc = [[OSRecordingViewController alloc] init];
            nav = [[OSNavigationController alloc] initWithRootViewController:vc];
            OSSideMenuController *sideMenuController = [[OSSideMenuController alloc] initWithRootViewController:nav];
            vc.delegate = (id)sideMenuController.leftSideViewController;
            [sideMenuController setRightViewSwipeGestureEnabled:NO];
            self.window.rootViewController = sideMenuController;
        }
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"FirstLoad"] == nil) {
        OSGuidingViewController *vc = [[OSGuidingViewController alloc] initWithNibName:@"OSGuidingViewController" bundle:nil];
        self.window.rootViewController = vc;
    }else {
        
        if ([shortcutItem.type isEqualToString:@"com.homeboy.record"]) {
            // 一秒
            OSNavigationController *nav = nil;
            OSRecordingViewController *vc = [[OSRecordingViewController alloc] init];
            nav = [[OSNavigationController alloc] initWithRootViewController:vc];
            OSSideMenuController *sideMenuController = [[OSSideMenuController alloc] initWithRootViewController:nav];
            vc.delegate = (id)sideMenuController.leftSideViewController;
            [sideMenuController setRightViewSwipeGestureEnabled:NO];
            self.window.rootViewController = sideMenuController;
            
        }else if ([shortcutItem.type isEqualToString:@"com.homeboy.diary"]) {
            // 日历
            OSNavigationController *nav = nil;
            nav = [[OSNavigationController alloc] initWithRootViewController:[[OSCalendarViewController alloc] init]];
            OSSideMenuController *sideMenuController = [[OSSideMenuController alloc] initWithRootViewController:nav];
            [sideMenuController setRightViewSwipeGestureEnabled:NO];
            self.window.rootViewController = sideMenuController;
            
        }else if ([shortcutItem.type isEqualToString:@"com.homeboy.photo"]) {
            // 世界
            OSNavigationController *nav = nil;
            nav = [[OSNavigationController alloc] initWithRootViewController:[[OSNextDayViewController alloc] init]];
            OSSideMenuController *sideMenuController = [[OSSideMenuController alloc] initWithRootViewController:nav];
            [sideMenuController setRightViewSwipeGestureEnabled:YES];
            self.window.rootViewController = sideMenuController;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:weixinAppKey]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:weixinAppKey]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
}

#pragma mark ------------- 推送 -------------------------
#pragma mark 注册推送成功
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    // 这是推送用的令牌，用户如果没开推送，或者拒绝了，这个就没有了！
//    // 获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
////    NSString *token = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
////    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//}
//
//#pragma mark 注册推送失败
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
//{
//
//}

#pragma mark - push notification
- (void)registerNotification
{
    // 注册推送
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        
//        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
//    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//    }
    
    
//#ifdef __IPHONE_8_0 //这里主要是针对iOS 8.0
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }  else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
//#else
//    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//#endif
    
    // 网络变化监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kNetworkDidChangedNotification object:nil];
}

#pragma mark ------------ 通知事件 -----------------------
- (void)networkChanged:(NSNotification *)notification
{
    [self startDetectNetwork];
}

#pragma mark ------------ 功能函数 -----------------------

- (void)configThirdPartySDK
{
    [WXApi registerApp:weixinAppKey];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:weiboAppKey];
}

- (void)initDataBase
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSString *pathOfDate = [documentPath stringByAppendingPathComponent:DATABASE_NAME];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *fromPath = [[mainBundle resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    
    if (![NSString emptyOrNull:pathOfDate]) {
        if (![fileManger fileExistsAtPath:pathOfDate]) {
            // 如果有账号密码则清空keychain
            [self copyTowDataBase:fileManger fromPath:fromPath pathOfDate:pathOfDate];
        }
    }
}

-(BOOL)copyTowDataBase:(NSFileManager *)fileManager fromPath:(NSString*)fromPath pathOfDate:(NSString*)pathOfDate
{
    [fileManager removeItemAtPath:pathOfDate error:NULL];
    
    BOOL successOfDate = [fileManager copyItemAtPath:fromPath toPath:pathOfDate error:NULL];
    if (!successOfDate) {
        // 拷贝失败
    }else {
    // 将db设置为不备份到itunes
        BOOL isDir = NO;
        NSURL *url = NULL;
        if ([fileManager fileExistsAtPath:pathOfDate isDirectory:&isDir]) {
            url = [NSURL fileURLWithPath:pathOfDate isDirectory:isDir];
        }
        if (url) {
            assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
            
            NSError *error = nil;
            BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                          forKey: NSURLIsExcludedFromBackupKey error: &error];
            if(!success){
//                DLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
            }
        }
    }
    return successOfDate;
}

- (void)startDetectNetwork
{
    if (self.networkUtil == nil) {
        self.networkUtil = [NetworkUtil sharedInstance];
    }
    switch (self.networkUtil.networkType) {
        case eNetworkType_None:
        {
            // 网络不可用
            __dataSource.isNetworkAvailable = NO;
            __dataSource.networkType = eNetworkType_None;
            break;
        }
        case eNetworkType_WIFI:
        {
            __dataSource.isNetworkAvailable = YES;
            __dataSource.networkType = eNetworkType_WIFI;
            break;
        }
        case eNetworkType_Cellular:
        {
            __dataSource.isNetworkAvailable = YES;
            __dataSource.networkType = eNetworkType_Cellular;
            break;
        }
        default:
            break;
    }
}

#pragma mark ------------------- 代理方法 -----------------------------
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{

}

@end
