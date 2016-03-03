//
//  MZLaunchManager.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZLaunchManager.h"
#import "MZMainViewController.h"
#import "AppDelegate.h"
#import "MZBaseNavigationViewController.h"
#import "MZTempMainViewController.h"
#import "MZloginViewController.h"

#define MZFIRSTLOGON_KEY @"firstLogon"

@implementation MZLaunchManager

static MZLaunchManager *_manager;

+ (instancetype)manager
{
    if (!_manager) {
        _manager = [[MZLaunchManager alloc] init];
    }
    return _manager;
}

//- (void)launch
//{
//    if ([userdefaultsDefine objectForKey:MZFIRSTLOGON_KEY]) {
//         [self logoutScreen];
//    }else {
//        [self startApplication];
//    }
//}


- (void)startApplication
{
    MZMainViewController *mainVC = [[MZMainViewController alloc]init];
    MZBaseNavigationViewController *mzBaseNC = [[MZBaseNavigationViewController alloc]initWithRootViewController:mainVC];
    [self getAppDelegate].window.rootViewController=mzBaseNC;
    
}

- (void)logoutScreen
{
    MZloginViewController *loginVC = [[MZloginViewController alloc]init];
    MZBaseNavigationViewController *mzBaseNC = [[MZBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self getAppDelegate].window.rootViewController=mzBaseNC;

}


- (void)tempMainViewController
{
    MZTempMainViewController *tempMainVC = [[MZTempMainViewController alloc]init];
    MZBaseNavigationViewController *mzBaseNC = [[MZBaseNavigationViewController alloc]initWithRootViewController:tempMainVC];
    [self getAppDelegate].window.rootViewController=mzBaseNC;

}


- (BOOL)logout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_id"];
    [userDefaults removeObjectForKey:@"account"];
    return [userDefaults synchronize];
}



- (AppDelegate *)getAppDelegate
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate);
}
@end
