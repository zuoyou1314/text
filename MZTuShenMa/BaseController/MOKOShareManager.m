//
//  MOKOShareManager.m
//  MOKODreamWork_iOS2
//
//  Created by zuo on 15/8/5.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import "MOKOShareManager.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
//#import "MOKOComplainViewController.h"
@implementation MOKOShareManager

static MOKOShareManager *shareManaager = nil;
+ (MOKOShareManager *)shareSingleton
{
    @synchronized(self){
        if (shareManaager == nil) {
            shareManaager = [[MOKOShareManager alloc]init];
        }
    }
    return shareManaager;
}


#pragma mark 注册友盟分享以及配置信息
- (void)shareConfig
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialData openLog:YES];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:MOKOWXAppKey appSecret:MOKOWXAppSecret url:MOKOShareUrl];
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开人人网SSO开关
//    [UMSocialRenrenHandler openSSO];
    
    //QQ
    [UMSocialData defaultData].extConfig.qqData.url = MOKOShareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = @"美空APP";
    
    //QQ空间
    [UMSocialData defaultData].extConfig.qzoneData.url = MOKOShareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.title = @"美空APP";
    
    //微信朋友
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = MOKOShareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"图什么";
    
    //微信朋友圈
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = MOKOShareUrl;
 //   [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"美空APP";
    
    //人人
    [UMSocialData defaultData].extConfig.renrenData.url=MOKOShareUrl;

    
    
    //注册微信
    [WXApi registerApp:MOKOWXAppKey];
    //设置图文分享
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    
}


//- (void)shareType:(MOKOShareButtonType)type shareWithViewController:(UIViewController *)shareVC shareText:(NSString *)shareText shareImage:(id)shareImage shareUrl:(NSString *)shareUrl
//{
//    
//    UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
//    [socialControllerService setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
//    switch (type) {
//        case MOKOShareButtonTypeWeiBo:
//        {
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            break;
//        case MOKOShareButtonTypeWeiXin:
//        {
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = MOKOShareUrl;
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            break;
//        case MOKOShareButtonTypePengYouQuan:
//        {
//         
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            break;
//        case MOKOShareButtonTypeQQ:
//        {
//             [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            
//            break;
//        case MOKOShareButtonTypeQQZone:
//        {
//            [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            
//            break;
//        case MOKOShareButtonTypeTXWeiBo:
//        {
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            break;
//        case MOKOShareButtonTypeRenRen:
//        {
//             [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren].snsClickHandler(shareVC,socialControllerService,YES);
//        }
//            break;
////        case MOKOShareButtonTypeJuBao:
////        {
////            MOKOComplainViewController *complainViewController=[[MOKOComplainViewController alloc] init];
////            [complainViewController setTabBarHidden:YES];
////            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
////            shareVC.navigationItem.backBarButtonItem = backButton;
////            [shareVC.navigationController pushViewController:complainViewController animated:NO];
////        }
////            break;
//        default:
//            break;
//    }
//}


//- (void)shareType:(MOKOShareButtonType)type shareWithViewController:(UIViewController *)shareVC  complainType:(MOKOComplainType)complainType girlid:(NSString *)girlid indexid:(NSString *)indexid
//{
//    MOKOComplainViewController *complainViewController=[[MOKOComplainViewController alloc] init];
//    [complainViewController setTabBarHidden:YES];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    shareVC.navigationItem.backBarButtonItem = backButton;
//    complainViewController.type = complainType;
//    complainViewController.touserid = girlid;
//    complainViewController.indexid = indexid;
//    [shareVC.navigationController pushViewController:complainViewController animated:NO];
//}

@end
