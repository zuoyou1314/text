//
//  MZNeedRegisteViewController.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZNeedRegisteViewController.h"
#import "AppDelegate.h"
#import "MZRegisterViewController.h"
#import "MZLaunchManager.h"
@interface MZNeedRegisteViewController ()<WechatLoginDelegate>
{
    BOOL _eventRegister;
    BOOL _eventWechat;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *registeButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@end

@implementation MZNeedRegisteViewController


- (instancetype)init
{
    if(self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZNeedRegisteViewController" owner:self options:nil] lastObject];
        [self setNavigationItem];
        [self.registeButton.layer setCornerRadius:22.0f];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).wechatLoginDelegate = self;
        
       
    }
    return self;
}

- (void) setNavigationDefaultLeftBarButton
{
    
    UIView *customView = [[UIView alloc]initWithFrame:rect(0, 0, 25, 25)];
    
    UIButton *lefrBarButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [lefrBarButtonTmp setBackgroundImage:[UIImage imageNamed:@"login_backHighlighted_temp"] forState:UIControlStateNormal];
    
    [lefrBarButtonTmp addTarget:self action:@selector(navigationDefaultLeftBarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [lefrBarButtonTmp setFrame:CGRectMake(0, 0, 25, 25)];
    
    [customView addSubview:lefrBarButtonTmp];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}




- (void) setNavigationItem
{
    [self setNavigationDefaultLeftBarButton];
    self.title = @"登录";
}

//微信登陆
- (IBAction)didClickWeChatButtonAction:(id)sender {
    NSLog(@"微信登陆");
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
    
    [[BaiduMobStat defaultStat] logEvent:@"wechatRegisterGuide" eventLabel:@"注册引导页-微信授权登录"];
    if(!_eventWechat) {
        _eventWechat = YES;
        [[BaiduMobStat defaultStat] eventStart:@"wechatRegisterGuide" eventLabel:@"注册引导页-微信授权登录"];
    } else {
        _eventWechat = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"wechatRegisterGuide" eventLabel:@"注册引导页-微信授权登录"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"wechatRegisterGuide" eventLabel:@"注册引导页-微信授权登录" durationTime:1000];
    
    
}

#pragma mark -----WechatLoginDelegate
- (void)wechatLoginSuccessWithDic:(NSDictionary *)dic
{
    [self getAccess_token:[dic objectForKey:@"code"]];
}
- (void)getAccess_token:(NSString *)wxCode
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",MOKOWXAppKey,MOKOWXAppSecret,wxCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                [self getUserInfo:[dic objectForKey:@"access_token"] openid:[dic objectForKey:@"openid"]];
                
            }
        });
    });
}

-(void)getUserInfo:(NSString *)access_token openid:(NSString *)openid
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                NSLog(@"dic = %@",dic);
                //                NSLog(@"nickname = %@",[dic objectForKey:@"nickname"]);
                //                NSLog(@"headimgurl = %@",[dic objectForKey:@"headimgurl"]);
                //                self.nickname.text = [dic objectForKey:@"nickname"];
                //                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                
                __weak typeof(self) weakSelf = self;
                MZLoginParam *param = [[MZLoginParam alloc] init];
                [param setAccount:[dic objectForKey:@"unionid"]];
                [param setWay:wxType];
                param.user_img = [dic objectForKey:@"headimgurl"];
                param.sex = [dic objectForKey:@"sex"];
                param.user_name = [dic objectForKey:@"nickname"];
                param.device_id = [userdefaultsDefine objectForKey:@"JPushRegisterId"];
                param.ios = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
                [self showHoldView];
                [MZRequestManger loginRequest:param success:^(NSDictionary *object) {
                    [weakSelf hideHUD];
                    [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:object];
                    NSString *userID = [NSString stringWithFormat:@"%@",[object objectForKey:@"id"]];
                    [userdefaultsDefine setObject:userID forKey:@"user_id"];
                    [userdefaultsDefine setObject:[object objectForKey:@"way"] forKey:@"way"];
                    [userdefaultsDefine setObject:[object objectForKey:@"account"] forKey:@"account"];
                    
                    if ([userdefaultsDefine objectForKey:@"JPushRegisterId"]) {
                        [self setJpushRegisterId:dic];
                    }
                    
                    [[MZLaunchManager manager] startApplication];
                } failure:^(NSString *errMsg,NSString *errCode) {
                    [weakSelf hideHUD];
                    [weakSelf showHUDWithText:errMsg];
                }];
                
            }
        });
        
    });
}

#pragma mark -- regist JPush id

-(void)setJpushRegisterId:(NSDictionary *)dic{
    
    MZLoginParam *param = [[MZLoginParam alloc] init];
    [param setAccount:[dic objectForKey:@"unionid"]];
    [param setWay:wxType];
    param.user_img = [dic objectForKey:@"headimgurl"];
    param.sex = [dic objectForKey:@"sex"];
    param.user_name = [dic objectForKey:@"nickname"];
    param.device_id = [userdefaultsDefine objectForKey:@"JPushRegisterId"];
    param.ios = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [MZRequestManger loginRequest:param success:^(NSDictionary *object) {
    } failure:^(NSString *errMsg,NSString *errCode) {
    }];
    
}



- (void)wechatLoginFailure
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"小图提示" message:@"登录失败,请稍候在试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了",nil];
    [alertView show];
    
}

- (void)wechatLoginCancel
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"小图提示" message:@"登录取消了,请稍候在试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了",nil];
    [alertView show];
}

//注册
- (IBAction)didClickRegisteButtonAction:(id)sender {
    
    [[BaiduMobStat defaultStat] logEvent:@"phoneRegisterGuide" eventLabel:@"注册引导页-手机号注册"];
    if(!_eventRegister) {
        _eventRegister = YES;
        [[BaiduMobStat defaultStat] eventStart:@"phoneRegisterGuide" eventLabel:@"注册引导页-手机号注册"];
    } else {
        _eventRegister = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"phoneRegisterGuide" eventLabel:@"注册引导页-手机号注册"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"phoneRegisterGuide" eventLabel:@"注册引导页-手机号注册" durationTime:1000];
    
    if(sender && [sender isKindOfClass:[UIButton class]])
    {
        MZRegisterViewController *controller = [[MZRegisterViewController alloc] init];
        [controller setIsNew:[(UIButton *)sender tag]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)setPhoneString:(NSString *)phoneString
{
    _phoneString = phoneString;
   
//    self.phoneLabel.text =  [NSString stringWithFormat:@"%@ 还没有注册过哦",self.phoneString];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}



@end
