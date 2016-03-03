//
//  MZloginViewController.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZloginViewController.h"
#import "MZRegisterViewController.h"
#import "MZHomeFootAnimationButton.h"
#import "AppDelegate.h"
#import "MZLaunchManager.h"
#import "UIImage+GIF.h"

@interface MZloginViewController ()<WechatLoginDelegate>
{
    BOOL _eventLogin;
    BOOL _eventRegister;
    BOOL _eventWechat;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHeightConstraionts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHeightConstraionts;
@property (weak, nonatomic) IBOutlet UIView *loginView;
//注册
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//登陆
@property (weak, nonatomic) IBOutlet UIButton *phoneNumLoginButton;
//微信
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTop;
#pragma mark ---- Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weChatButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeight;



@end

@implementation MZloginViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZloginViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void) setUIDef
{
//    _loginViewBottom.constant = -SCREEN_HEIGHT-SCREEN_HEIGHT;
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320)/2, 50, 320, 300)];
//    [imageV setImage:[UIImage sd_animatedGIFNamed:@"welcome_gif"]];
//    [self.lunchView addSubview:imageV];
//    
//    [self.window bringSubviewToFront:self.lunchView];
//    
//    [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[MZLaunchManager manager] startApplication];
//    });

    self.leftHeightConstraionts.constant = 0.8f;
    self.rightHeightConstraionts.constant = 0.8f;
    [self.loginButton.layer setCornerRadius:_loginButtonHeight.constant/2];
    [self.loginButton.layer setBorderWidth:0.5f];
//    [self.loginButton.layer setBorderColor:[self.loginButton titleColorForState:UIControlStateNormal].CGColor];
    [self.loginButton.layer setBorderColor:UIColorFromRGB(0x6fabf5).CGColor];

    
    [self.phoneNumLoginButton.layer setCornerRadius:_loginButtonHeight.constant/2];
    
    [self.weChatButton.layer setCornerRadius:_weChatButtonHeight.constant/2];
    
    if(iPhone5){
         [self.backImageView setImage:[UIImage imageNamed:@"bj"]];
//         [self.backImageView setImage:[UIImage sd_animatedGIFNamed:@"welcome_gif"]];
    }
    
//        _loginView.alpha = 0.5;
//    [UIView animateWithDuration:0.5 animations:^{
////        _loginView.alpha = 1;
////        self.view.alpha = 1;
//    } completion:^(BOOL finished) {
////        
//    }];

    if(iPhone6 || iPhone6P) [self.backImageView setImage:[UIImage imageNamed:@"bjiPhone6"]];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).wechatLoginDelegate = self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    self.lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//    self.lunchView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    [self.view addSubview:self.lunchView];
//    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 300)];
//    [imageV setImage:[UIImage sd_animatedGIFNamed:@"welcome_gif"]];
//    [self.view addSubview:imageV];
//    
//    [self.view bringSubviewToFront:self.lunchView];
//    
//    [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
//}
//
//- (void)removeLun
//{
//    [self.lunchView removeFromSuperview];
//}



- (IBAction)loginButtonTouchUpInside:(id)sender
{
    
    if ([(UIButton *)sender tag]) {
        NSLog(@"注册");
        [[BaiduMobStat defaultStat] logEvent:@"phoneRegister" eventLabel:@"未登录首页-手机号注册"];
        if(!_eventRegister) {
            _eventRegister = YES;
            [[BaiduMobStat defaultStat] eventStart:@"phoneRegister" eventLabel:@"未登录首页-手机号注册"];
        } else {
            _eventRegister = NO;
            [[BaiduMobStat defaultStat] eventEnd:@"phoneRegister" eventLabel:@"未登录首页-手机号注册"];
        }
        [[BaiduMobStat defaultStat] logEventWithDurationTime:@"phoneRegister" eventLabel:@"未登录首页-手机号注册" durationTime:1000];
    }else{
        NSLog(@"登陆");
        [[BaiduMobStat defaultStat] logEvent:@"phoneLogin" eventLabel:@"未登录首页-手机号登陆"];
        if(!_eventLogin) {
            _eventLogin = YES;
            [[BaiduMobStat defaultStat] eventStart:@"phoneLogin" eventLabel:@"未登录首页-手机号登陆"];
        } else {
            _eventLogin = NO;
            [[BaiduMobStat defaultStat] eventEnd:@"phoneLogin" eventLabel:@"未登录首页-手机号登陆"];
        }
        [[BaiduMobStat defaultStat] logEventWithDurationTime:@"phoneLogin" eventLabel:@"未登录首页-手机号登陆" durationTime:1000];
    }
    
    if(sender && [sender isKindOfClass:[UIButton class]])
    {
        MZRegisterViewController *controller = [[MZRegisterViewController alloc] init];
        [controller setIsNew:[(UIButton *)sender tag]];
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//微信登陆
- (IBAction)didClickWeChatButtonAction:(id)sender {
    NSLog(@"微信登陆");
    
    [[BaiduMobStat defaultStat] logEvent:@"wechatLogin" eventLabel:@"未登录首页-微信授权登陆"];
    if(!_eventWechat) {
        _eventWechat = YES;
        [[BaiduMobStat defaultStat] eventStart:@"wechatLogin" eventLabel:@"未登录首页-微信授权登陆"];
    } else {
        _eventWechat = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"wechatLogin" eventLabel:@"未登录首页-微信授权登陆"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"wechatLogin" eventLabel:@"未登录首页-微信授权登陆" durationTime:1000];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
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
        [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:object];
//        [userdefaultsDefine setObject:[object objectForKey:@"id"] forKey:@"user_id"];
//        [userdefaultsDefine setObject:[object objectForKey:@"way"] forKey:@"way"];
//        [userdefaultsDefine setObject:[object objectForKey:@"account"] forKey:@"account"];
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



- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
