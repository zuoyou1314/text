//
//  MZRegisterViewController.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZRegisterViewController.h"
#import "MZRegiSendMessageViewController.h"
#import "MZNeedRegisteViewController.h"
#import "MZRequestManger+User.h"
#import "UserHelp.h"
#import "MZLaunchManager.h"
#import "MZForgetPasswordViewController.h"//重置密码
NS_ENUM(NSInteger, RegtextFieldTag)
{
    phoneNumTextTag = 99,
    passWrodTextTag = 999,
};

@interface MZRegisterViewController () <UITextFieldDelegate>
{
    BOOL _eventLogin;
    BOOL _eventRegister;
    BOOL _eventForgetPass;
}

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *passWordView;

//忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;

@end

@implementation MZRegisterViewController

- (instancetype)init
{
    if(self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZRegisterViewController" owner:self options:nil] lastObject];
        [self setUIDef];
        [self setNavigationItem];
       
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void) setUIDef
{
    [self.phoneNumTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.phoneNumTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneNumTextField setDelegate:self];
    [self.phoneNumView.layer setCornerRadius:1.5];
    self.phoneNumView.layer.masksToBounds = YES;
    [self.phoneNumTextField.layer setCornerRadius:1.5];
    self.phoneNumTextField.layer.masksToBounds = YES;
    
    [self.passWordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWordTextField setDelegate:self];
    [self.passWordTextField.layer setCornerRadius:1.5];
    self.passWordTextField.layer.masksToBounds = YES;
    [self.passWordView.layer setCornerRadius:1.5];
    self.passWordView.layer.masksToBounds = YES;
    
    [self.loginButton.layer setCornerRadius:1.5];
    self.loginButton.layer.masksToBounds = YES;
//    // 每隔0.1秒检查输入框
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkCardInfoInput) userInfo:nil repeats:YES];
}

- (void)setIsNew:(BOOL)isNew
{
    _isNew = isNew;
    if (!self.isNew){
        self.title = @"登录";
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    }else{
        self.title = @"注册";
        _forgetPasswordButton.hidden = YES;
        [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
    }
}


- (void) setNavigationItem
{
    [self setNavigationDefaultLeftBarButton];
}

// -- MARK 验证是否是手机号
- (BOOL) isPhoneNum:(NSString *)phoneNum
{
    NSError *error = [[NSError alloc] init];
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:kMobileNumberPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *regArr = [regular matchesInString:phoneNum options:0 range:NSMakeRange(0, [phoneNum length])];
    if(regArr.count > 0) return YES;
    else return NO;
}

- (IBAction)loginButtonTouchUpInside:(id)sender
{
    if ([self.title isEqualToString:@"登录"]) {
        [[BaiduMobStat defaultStat] logEvent:@"loginButton" eventLabel:@"登录页-登录"];
        if(!_eventLogin) {
            _eventLogin = YES;
            [[BaiduMobStat defaultStat] eventStart:@"loginButton" eventLabel:@"登录页-登录"];
        } else {
            _eventLogin = NO;
            [[BaiduMobStat defaultStat] eventEnd:@"loginButton" eventLabel:@"登录页-登录"];
        }
        [[BaiduMobStat defaultStat] logEventWithDurationTime:@"loginButton" eventLabel:@"登录页-登录" durationTime:1000];
    }else{
        [[BaiduMobStat defaultStat] logEvent:@"registerButton" eventLabel:@"注册页-注册"];
        if(!_eventRegister) {
            _eventRegister = YES;
            [[BaiduMobStat defaultStat] eventStart:@"registerButton" eventLabel:@"注册页-注册"];
        } else {
            _eventRegister = NO;
            [[BaiduMobStat defaultStat] eventEnd:@"registerButton" eventLabel:@"注册页-注册"];
        }
        [[BaiduMobStat defaultStat] logEventWithDurationTime:@"registerButton" eventLabel:@"注册页-注册" durationTime:1000];
    }
    
    
    
    
    if (sender && [sender isKindOfClass:[UIButton class]])
    {
        if(![self isPhoneNum:self.phoneNumTextField.text])
        {
            [self showHUDWithText:@"您输入的手机号有误"]; return;
        }
        
        if ([self.passWordTextField.text length] < 6){
            [self showHUDWithText:@"您输入的密码有误"]; return;
        }
        
        
        __weak typeof(self) weakSelf = self;
        if (!self.isNew)
        {
            // 手机号登陆接口
            MZLoginParam *param = [[MZLoginParam alloc] init];
            [param setAccount:self.phoneNumTextField.text];
            [param setWay:phoneNumType];
            [param setPass:self.passWordTextField.text];
            param.device_id = [userdefaultsDefine objectForKey:@"JPushRegisterId"];
            param.ios = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
            
            [self showHoldView];
            [MZRequestManger loginRequest:param success:^(NSDictionary *object) {
            [weakSelf hideHUD];
                
            [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:object];
            [self.passWordTextField resignFirstResponder];
            [self.phoneNumTextField resignFirstResponder];
            NSString *userID = [NSString stringWithFormat:@"%@",[object objectForKey:@"id"]];
            [userdefaultsDefine setObject:userID forKey:@"user_id"];
            [userdefaultsDefine setObject:[object objectForKey:@"way"] forKey:@"way"];
            [userdefaultsDefine setObject:[object objectForKey:@"account"] forKey:@"account"];
                
            if ([userdefaultsDefine objectForKey:@"JPushRegisterId"]) {
                      [self setJpushRegisterId];
            }
                
            [[MZLaunchManager manager] startApplication];
            } failure:^(NSString *errMsg,NSString *errCode) {
                [weakSelf hideHUD];
                if([errCode integerValue] == 10004)
                {
                    MZNeedRegisteViewController *needRegisteVC = [[MZNeedRegisteViewController alloc]init];
                    needRegisteVC.phoneString = weakSelf.phoneNumTextField.text;
                    [weakSelf.navigationController.navigationBar lt_reset];
                    [weakSelf.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
                    [weakSelf.navigationController pushViewController:needRegisteVC animated:YES];
                }
                else
                    [weakSelf showHUDWithText:errMsg];
            }];
        }
        else
        {
            // 手机号注册接口
            MZPhoneValidateParam *param = [[MZPhoneValidateParam alloc] init];
            [param setPhone:self.phoneNumTextField.text];
            [self showHoldView];
            [MZRequestManger phoneValidateRequest:param success:^(NSString *object) {
                [weakSelf hideHUD];
                
                [[UserHelp sharedUserHelper] setUserName:weakSelf.phoneNumTextField.text];
                [[UserHelp sharedUserHelper] setPassWord:weakSelf.passWordTextField.text];
                [[UserHelp sharedUserHelper] setMsgCode:object];
                
                MZRegiSendMessageViewController *regiSendMessageVC = [[MZRegiSendMessageViewController alloc]init];
                regiSendMessageVC.type = MZSendMessageTypeRegister;
                regiSendMessageVC.messageCodeString = object;
                [weakSelf.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
                [weakSelf.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                [weakSelf.navigationController pushViewController:regiSendMessageVC animated:YES];
                
            } failure:^(NSString *errMsg) {
                [weakSelf hideHUD];
                [weakSelf showHUDWithText:errMsg];
            }];
        }
    }
}

#pragma mark -- regist JPush id

-(void)setJpushRegisterId{
    
    MZLoginParam *param = [[MZLoginParam alloc] init];
    [param setAccount:self.phoneNumTextField.text];
    [param setWay:phoneNumType];
    [param setPass:self.passWordTextField.text];
    param.device_id = [userdefaultsDefine objectForKey:@"JPushRegisterId"];
    param.ios = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [MZRequestManger loginRequest:param success:^(NSDictionary *object) {
    } failure:^(NSString *errMsg,NSString *errCode) {
    }];

}



//点击忘记密码按钮的响应方法
- (IBAction)didClickForgetPasswordAction:(id)sender {
    
    [[BaiduMobStat defaultStat] logEvent:@"forgetPass" eventLabel:@"登录页-忘记密码"];
    if(!_eventForgetPass) {
        _eventForgetPass = YES;
        [[BaiduMobStat defaultStat] eventStart:@"forgetPass" eventLabel:@"登录页-忘记密码"];
    } else {
        _eventForgetPass = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"forgetPass" eventLabel:@"登录页-忘记密码"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"forgetPass" eventLabel:@"登录页-忘记密码" durationTime:1000];
    
    MZForgetPasswordViewController *forgetPasswordVC = [[MZForgetPasswordViewController alloc]init];
    if ([self isPhoneNum:_phoneNumTextField.text]) {
        forgetPasswordVC.phoneString = _phoneNumTextField.text;
    }
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == phoneNumTextTag)
    {
        if (textField.text.length + string.length > 11)
        {
            return NO;
        }
    }
    return YES;
}




- (void)requestAlbumlistsWith:(NSString *)userName
{
    __weak typeof(self) weakSelf = self;
    MZMainParam *mainParam = [[MZMainParam alloc]init];
    mainParam.user_id = [UserHelp sharedUserHelper].userId;
    mainParam.type = @"create_time";
    mainParam.page = 1;
    [self showHoldView];
    [MZRequestManger AlbumlistsRequest:mainParam success:^(NSArray *responseData,NSDictionary *object) {
        [weakSelf hideHUD];
         MZModel *model = [MZModel objectWithKeyValues:object];
        if (model.errCode == 10002) {
            [userdefaultsDefine setObject:userName forKey:@"firstLogon"];
            [[MZLaunchManager manager] tempMainViewController];
        }
         [[MZLaunchManager manager] startApplication];
          } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
        if ([errCode isEqualToString:@"10002"]) {
            [userdefaultsDefine setObject:userName forKey:@"firstLogon"];
            [[MZLaunchManager manager] tempMainViewController];
        }
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passWordTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
}


//-(void)checkCardInfoInput{
//    BOOL isValid = YES;
//    if ([self.passWordTextField.text length] <= 6){
//        self.passWordTextField.textColor = [UIColor redColor];
//        isValid = NO;
//    }
//   
//    // 其他验证
//    
//    if (isValid == YES) {
//        self.loginButton.enabled = YES;
//    }
//    else{
//        self.loginButton.enabled = NO;
//    }
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//}


- (AppDelegate *)getAppDelegate
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate);
}
@end
