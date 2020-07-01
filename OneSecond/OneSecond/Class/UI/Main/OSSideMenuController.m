//
//  OSSideMenuController.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSSideMenuController.h"
#import "OSLeftSideViewController.h"
#import "OSVideoPlayerViewController.h"

@interface OSSideMenuController ()

@end

@implementation OSSideMenuController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        self.leftSideViewController = [[OSLeftSideViewController alloc] init];
        self.leftSideViewController.view.backgroundColor = [UIColor clearColor];
        
        CGFloat videoWidth = 280.0f;
        CGFloat leftWidth = 250.0f;
        if ([OSDevice isDeviceIPhone4s]) {
            videoWidth = 280.0f;
            leftWidth = 223.0;
        }else if ([OSDevice isDeviceIPhone5]) {
            videoWidth = 280.0f;
            leftWidth = 223.0f;
        }else if ([OSDevice isDeviceIPhone6Plus]) {
            videoWidth = 355.0f;
            leftWidth = 279.0f;
        }else {
            videoWidth = 320.0f;
            leftWidth = 256.0f;
        }

        [self setLeftViewEnabledWithWidth:leftWidth presentationStyle:LGSideMenuPresentationStyleScaleFromBig alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
        self.leftViewBackgroundImage = [UIImage imageNamed:@"bg"];
        
        [self.leftView addSubview:self.leftSideViewController.view];
        
        [self setRightViewEnabledWithWidth:videoWidth presentationStyle:LGSideMenuPresentationStyleSlideBelow alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPhoneLandscape];
       
        self.videoPlayerViewController =  [[OSVideoPlayerViewController alloc] init];
        
        [self.rightView addSubview:self.videoPlayerViewController.view];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
