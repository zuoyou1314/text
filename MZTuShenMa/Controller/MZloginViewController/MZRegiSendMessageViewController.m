//
//  MZRegiSendMessageViewController.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/24.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZRegiSendMessageViewController.h"
#import "MZPrintUserInfoViewController.h"
#import "MZRequestManger+User.h"
#import "UserHelp.h"
#import "MZForgetPasswordParam.h"
#import "MZForgetPasswordViewController.h"
#import "MZloginViewController.h"
static NSString * const kTitle = @"我们已发送 验证短信 到您的手机号";

@interface MZRegiSendMessageViewController ()<UIAlertViewDelegate>
{
    int _sendTime;
    NSTimer *_sendTimer;
}
@property (weak, nonatomic) IBOutlet UITextField *messageCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *reSendButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation MZRegiSendMessageViewController

- (instancetype)init
{
    if(self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZRegiSendMessageViewController" owner:self options:nil] lastObject];
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
    self.title = @"填写验证码";
//    [self.messageCodeTextField.layer setCornerRadius:5.0f];
//    [self.messageCodeTextField.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.messageCodeTextField.layer setBorderWidth:.3f];
    
//    [self.reSendButton.layer setCornerRadius:5.0f];
    
    [self.messageCodeTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
//    [self.commitButton.layer setCornerRadius:25.0f];
    
    NSString *phoneNum = [NSString stringWithFormat:@"%@",[[UserHelp sharedUserHelper] userName]];
    [self setPhoneNumText:phoneNum];
    
    _sendTime=TIMER;
    
    [self resetTimer];
}

- (void) setNavigationItem
{
    [self setNavigationDefaultLeftBarButton];
}


- (void) setPhoneNumText:(NSString *)phoneNum
{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n%@",phoneNum,kTitle]];
    [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, phoneNum.length)];
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(0, phoneNum.length)];
    [aString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(phoneNum.length, kTitle.length+2)];
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(phoneNum.length, kTitle.length+2)];
    [self.titleLabel setAttributedText:aString];
}





//重新获取验证码的响应方法
- (IBAction)didClickReSendButtonAction:(id)sender {
//     NSString *phonetext=_messageCodeTextField.text;
//    if ([phonetext isEqualToString:@""]||phonetext==nil) {
//        [self phoneNull];
//    }else{
//        if (![phonetext isValidPhoneNumber]) {
//            [self phoneError];
//        }else{
    MZPhoneValidateParam *param = [[MZPhoneValidateParam alloc] init];
    if (self.type == MZSendMessageTypePassword) {
        param.reset = @"1";
    }
    [param setPhone:[[UserHelp sharedUserHelper] userName]];
    [self showHoldView];
    __weak typeof(self) weakSelf = self;
    [MZRequestManger phoneValidateRequest:param success:^(NSString *object) {
        [weakSelf hideHUD];
        [self sendSuccess];
        [self resetTimer];
    } failure:^(NSString *errMsg) {
        [weakSelf hideHUD];
        [weakSelf showHUDWithText:errMsg];
    }];
    //
    //        }
    //    }
    [self resetUI];
    
}


//提交的响应方法
- (IBAction)commitButtonTouchUpInside:(id)sender
{
       __weak typeof(self) weakSelf = self;
            if(sender && [sender isKindOfClass:[UIButton class]])
            {
                switch (self.type) {
                    case MZSendMessageTypeRegister:
                    {
                        if (![_messageCodeTextField.text isEqualToString:_messageCodeString]) {
                            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填入正确的验证码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                            [alterView show];
                        }else{
                            [self showHoldView];
                            [MZRequestManger RegisterPhoneRequestsuccess:^(NSDictionary *object) {
                                [weakSelf hideHUD];
                                NSLog(@"object= %@",object);
                                NSString *userID = [NSString stringWithFormat:@"%@",[object objectForKey:@"id"]];
                                [userdefaultsDefine setObject:userID forKey:@"user_id"];
                                [userdefaultsDefine setObject:[object objectForKey:@"account"] forKey:@"account"];
                                [[UserHelp sharedUserHelper] setUserId:userID];
                                MZPrintUserInfoViewController *printUserInfoVC = [[MZPrintUserInfoViewController alloc] init];
                                printUserInfoVC.user_id = userID;
                                [weakSelf.navigationController pushViewController:printUserInfoVC animated:YES];
                            } failure:^(NSString *errMsg) {
                                [weakSelf hideHUD];
                                [weakSelf showHUDWithText:errMsg];
                            }];

                        }

                    }
                        break;
                    case MZSendMessageTypePassword:
                    {
                        if (![_messageCodeTextField.text isEqualToString:_messageCodeString]) {
                            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"小图提示" message:@"请填入正确的验证码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                            [alterView show];
                        }else{
                            MZForgetPasswordParam *param = [[MZForgetPasswordParam alloc]init];
                            param.phone = [[UserHelp sharedUserHelper] userName];
                            param.pass = [[UserHelp sharedUserHelper] passWord];
                            param.reset = @"1";
                            param.device_id = [userdefaultsDefine objectForKey:@"JPushRegisterId"];
                            [_messageCodeTextField resignFirstResponder];
                            [self showHoldView];
                            [MZRequestManger forgetPasswordRequest:param success:^(NSString *object,NSString *errMsg) {
                                [weakSelf hideHUD];
                            
                                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"小图提示" message:errMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                alterView.tag = 3000;
                                [alterView show];
                                //                            MZForgetPasswordViewController *forgetVC = [[MZForgetPasswordViewController alloc]init];
                                //                            [self.navigationController pushViewController:forgetVC animated:YES];
                            } failure:^(NSString *errMsg) {
                                [weakSelf hideHUD];
                                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"小图提示" message:errMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                [alterView show];
                                //                            [weakSelf showHUDWithText:errMsg];
                            }];

                            
                        }
                        
                        
                        }
                        break;
                        
                    default:
                        break;
                    }
}

}


#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000 && buttonIndex == 0) {
        MZloginViewController *loginVC = [[MZloginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}






#pragma mark -- Private Method

/**
 *  空手机号提示
 */
-(void)phoneNull{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alterView show];
}



/**
 *  手机号错误提示
 */
-(void)phoneError{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alterView show];
}

/**
 *  发送成功提示
 */
-(void)sendSuccess{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alterView show];
}

/**
 *  重置计时器
 */
-(void)resetTimer{
    _sendTimer=[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(changeSendButtonStatus) userInfo:self repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_sendTimer forMode:NSDefaultRunLoopMode];
    [_sendTimer fire];
}

/**
 *  倒计时
 */
-(void)changeSendButtonStatus{
    if(_sendTime!=0){
        _reSendButton.enabled=NO;
        [_reSendButton setTitle:[@"等待" stringByAppendingString:[NSString stringWithFormat:@"%d",_sendTime]] forState:UIControlStateNormal];
        _sendTime--;
    }else{
        [_sendTimer invalidate];
        _reSendButton.enabled=YES;
        [_reSendButton setTitle:@"重新获取验证码(60s)" forState:UIControlStateNormal];
        _sendTime=TIMER;
    }
}

/**
 *  重置UI
 */
-(void)resetUI{
    [_messageCodeTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetUI];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//}



@end
