//
//  AppDelegate.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "AppDelegate.h"
#import "MZLaunchManager.h"
#import "MOKOShareManager.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "APService.h"
#import "UIImage+GIF.h"
#import "MZRequestManger.h"
#import "MZRequestManger+User.h"
#import "MZTempMainViewController.h"
#import "MZBaseNavigationViewController.h"
#import "BaiduMobStat.h"
#import "MZDownLoadParam.h"
#import "MZRootViewController.h"
#import "MRGuideViewController.h"
#import "OKNetworkingManager.h"
@interface AppDelegate ()
{
    NSString *_downUrl;
}
@end

@implementation AppDelegate

/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:BaiDuReleaseAppkey];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self getVersion];
    
    // 初始化百度统计SDK
    [self startBaiduMobStat];
    
    //启动网络模块(必须放在最先）
    [[OKNetworkingManager sharedInstance] start];
    
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    //友盟分享配置文件
    [[MOKOShareManager shareSingleton]shareConfig];
    //向微信注册
    [WXApi registerApp:MOKOWXAppKey withDescription:@"weixin"];
    
// Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert)categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
#else
             //categories nil
            categories:nil];
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
    [APService setupWithOption:launchOptions];
    
     MZRootViewController *rootVC = [[MZRootViewController alloc]init];
    //引导界面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLuanch"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstCreatedAlbumView"] &&![[NSUserDefaults standardUserDefaults] boolForKey:@"firstCreatePhotoView"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInviteFriendView"]) {
    
        [userdefaultsDefine setBool:YES forKey:@"firstCreatedAlbumView"];
        [userdefaultsDefine setBool:YES forKey:@"firstCreatePhotoView"];
        [userdefaultsDefine setBool:YES forKey:@"firstInviteFriendView"];
        UINavigationController *rootNC = [[UINavigationController alloc]initWithRootViewController:rootVC];
        self.window.rootViewController = rootNC;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MRGuideViewController show];
        });
        
    }else{
            //
//            self.lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//            self.lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
//            [self.window addSubview:self.lunchView];
        
        
            //    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320)/2, 50, 320, 300)];
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 300)];
//            [imageV setImage:[UIImage sd_animatedGIFNamed:@"welcome_gif"]];
//            [self.lunchView addSubview:imageV];
        
//            [self.window bringSubviewToFront:self.lunchView];
        
//            [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
        
            UINavigationController *rootNCSS = [[UINavigationController alloc]initWithRootViewController:rootVC];
            self.window.rootViewController = rootNCSS;
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[MZLaunchManager manager] startApplication];
//            });
    }
    
    
    return YES;
}

//- (void)removeLun
//{
//    [self.lunchView removeFromSuperview];
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url] ||  [WXApi handleOpenURL:url delegate:self];;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url] ||  [WXApi handleOpenURL:url delegate:self];;
}

#pragma mark ------ WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        NSDictionary *dic = @{@"code":code};
        [self.wechatLoginDelegate wechatLoginSuccessWithDic:dic];
    }
    if (aresp.errCode == -4) {
        [self.wechatLoginDelegate wechatLoginFailure];
    }
    if (aresp.errCode == -2) {
        [self.wechatLoginDelegate wechatLoginCancel];
    }
    
}

#pragma mark -- 极光推送
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    NSLog(@"registrationID===%@",[APService registrationID]);
    [userdefaultsDefine setObject:[APService registrationID]forKey:@"JPushRegisterId"];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    NSLog(@"%@",@"接收消息通知");
    NSLog(@"userInfo===%@",userInfo);
//    NSLog(@"registrationID===%@",[APService registrationID]);
//        [userdefaultsDefine setObject:[APService registrationID]forKey:@"JPushRegisterId"];
    [APService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    // 处理收到的APNS消息，向服务器上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      [APService setBadge:0];
      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
      [[OKNetworkingManager sharedInstance] suspend];
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [self getVersion];
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[OKNetworkingManager sharedInstance] resume];
  

}

//检测新版本
- (void)getVersion
{
//    NSString *version=[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
//    [MZRequestManger checkRequest:nil success:^(NSDictionary *object) {
//        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
//    } failure:^(NSString *errMsg, NSString *errCode) {
//        
//    }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://api.fir.im/apps/latest/5602bfc3b5dac33b35000805?api_token=24a4fb1524e5cd7164ce873706bbc9e7" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
//        _downUrl = [responseObject objectForKey:@"direct_install_url"];
        _downUrl = [responseObject objectForKey:@"update_url"];
        NSLog(@"direct_install_url = %@",_downUrl);
        NSString *version=[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSLog(@"version = %.1f",[version floatValue]);
        NSLog(@"versionShort = %.1f",[[responseObject objectForKey:@"build"]floatValue]);
        
        if ([[responseObject objectForKey:@"build"]floatValue]<=[version floatValue]) {
            return ;
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本,请及时更新" delegate:self cancelButtonTitle:@"我要更新" otherButtonTitles:@"继续使用",nil];
            [alertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            MZDownLoadParam *downLoadParam = [[MZDownLoadParam alloc]init];
            downLoadParam.photo_type = @"ios";
            [MZRequestManger downLoadParamRequest:downLoadParam success:^(NSDictionary *object) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[object objectForKey:@"url"]]];
            } failure:^(NSString *errMsg, NSString *errCode) {
            }];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downUrl]];
        }
    }
}


-(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString{
    NSLog(@"请求状态: %@",@"success");
    NSLog(@"状态码: %ld",(long)statusCode);
    NSLog(@"请求响应结果: %@",responseObject);
    NSLog(@"请求响应结果: %@",responseString);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"进入前台");
    MZBaseNavigationViewController *NC = (MZBaseNavigationViewController *)self.window.rootViewController;
    if ( [[NC.viewControllers objectAtIndex:0] isKindOfClass:[MZTempMainViewController class]]) {
        MZTempMainViewController *tempVC = [NC.viewControllers objectAtIndex:0];
        [tempVC someMethod];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     [[OKNetworkingManager sharedInstance] stop];
}

@end
