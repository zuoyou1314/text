//
//  OKNetworkingManager.m
//  OKLinkWallet
//
//  Created by chenzs on 15/5/9.
//  Copyright (c) 2015年 OKLink. All rights reserved.
//

#import "OKNetworkingManager.h"
#import "AFNetworkActivityIndicatorManager.h"

//默认请求最大线程
#define DEFAUT_MAX_REQUEST  4
#define OK_SESSION_COOKIES_KEY  @"ok_session_cookies_$%#"
#define kNetworkChangedNotificationKey  @"com.oklink.wallet.NetworkChanged"     //网络改变通知

@interface OKNetworkingManager()
@property (nonatomic, strong) AFNetworkReachabilityManager* reachabilityMgr;
@property (readwrite, nonatomic, copy) NSString *userAgent;

@end
 
@implementation OKNetworkingManager

+(OKNetworkingManager*)sharedInstance{
    static OKNetworkingManager *instance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t,^{
        instance = [[super allocWithZone:NULL]init];
    });
    return instance;
} 

+(id)allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
 

-(instancetype)init{
    if(self = [super init]){
        
        self.requestQueue = [[NSOperationQueue alloc]init];
        [self.requestQueue setMaxConcurrentOperationCount:DEFAUT_MAX_REQUEST];
        self.netStatus = OKNetworkStatusUnknown;
        
        //启动网络状态监控
        self.reachabilityMgr = [AFNetworkReachabilityManager sharedManager];
        __weak typeof (self)weakSelf = self;
        [self.reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            NSLog(@"网络状态监控--状态:%@",AFStringFromNetworkReachabilityStatus(status));
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"没有网络(断网)");
                    strongSelf.netStatus = OKNetworkStatusNotReachable;
                    
//                    _isShowAlert = YES;
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的网络已断开..." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    
//                    [strongSelf postNetworkStatusNotificationWithStatus:NO];
//                    OLWBaseViewController *vc = (OLWBaseViewController *)[UIViewController getCurrentViewController];
//                    if (vc && [vc isKindOfClass:[OLWBaseViewController class]] && !vc.hideTopError) {
//                        [OLWHUD showTopAlertWithTitle:@"网络未连接" position:(STATUSBAR_HEIGHT + NAVIGATION_HEIGHT)  autoClose:NO];
//                    }
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    strongSelf.netStatus = OKNetworkStatusViaWiFi;
//                    [strongSelf postNetworkStatusNotificationWithStatus:YES];
//                    [OLWHUD hideTopAlert];
                    NSLog(@"WIFI");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    strongSelf.netStatus = OKNetworkStatusViaWWAN;
                    NSLog(@"手机自带网络");
//                    [strongSelf postNetworkStatusNotificationWithStatus:YES];
//                     [OLWHUD hideTopAlert];
                    break;
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知网络");
                    strongSelf.netStatus = OKNetworkStatusUnknown;
//                    [strongSelf postNetworkStatusNotificationWithStatus:NO];
                    break;
                default:
                    strongSelf.netStatus = (OKNetworkStatus)status;
//                    [strongSelf postNetworkStatusNotificationWithStatus:NO];
                    break;
            }
        }];
        [self.reachabilityMgr stopMonitoring];
        
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        
   // #warning AllowInvalidCertificates
    //    self.securityPolicy.allowInvalidCertificates = YES;
        [AFNetworkActivityIndicatorManager sharedManager].enabled =YES;
    }
    return self;
}

//- (void)postNetworkStatusNotificationWithStatus:(BOOL)status {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkChangedNotificationKey object:nil userInfo:@{@"status":@(status)}];
//}
//
-(void)start{
//    [self.dnManager start];
    [self resume];
}
//
-(void)suspend{
//    OKLogV();
    
//    [self.dnManager suspend];
    [self.requestQueue cancelAllOperations];
    [self.reachabilityMgr stopMonitoring];
}
//
-(void)resume{
//    OKLogV();
//    [self.dnManager resume];
    [self.reachabilityMgr startMonitoring];
}

-(void)stop{
//    OKLogV();
    [self suspend];
//    [self.dnManager stop];
}


@end
