//
//  MZForgetPasswordViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/11.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZForgetPasswordViewController.h"
#import "MZRegiSendMessageViewController.h"
@interface MZForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation MZForgetPasswordViewController

- (instancetype)init
{
    if(self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZForgetPasswordViewController" owner:self options:nil] lastObject];
        [self setNavigationItem];
        [self setUIDef];
    }
    return self;
}

- (void) setNavigationItem
{
    [self setNavigationDefaultLeftBarButton];
    self.title = @"重置密码";
}

- (void)setUIDef
{
    [_phoneNumView.layer setCornerRadius:1.5];
    _phoneNumView.layer.masksToBounds = YES;
    
    [_passWordView.layer setCornerRadius:1.5];
    _passWordView.layer.masksToBounds = YES;
    
    [_nextStepButton.layer setCornerRadius:1.5];
    _nextStepButton.layer.masksToBounds = YES;
    
    [self.backView.layer setCornerRadius:5.0f];
    [self.backView.layer setBorderWidth:.8f];
    [self.backView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.nextStepButton.layer setCornerRadius:25.0f];
    [self.phoneNumTextField setKeyboardType:UIKeyboardTypePhonePad];
    
    [self.phoneNumTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    if ([userdefaultsDefine objectForKey:@"account"]) {
        self.phoneNumTextField.text = [userdefaultsDefine objectForKey:@"account"];
        self.phoneNumTextField.enabled = NO;
    }
    
    
}

- (void)setPhoneString:(NSString *)phoneString
{
    _phoneString = phoneString;
    if ([userdefaultsDefine objectForKey:@"account"]) {
        self.phoneNumTextField.text = [userdefaultsDefine objectForKey:@"account"];
        self.phoneNumTextField.enabled = NO;
    }else{
         self.phoneNumTextField.text = self.phoneString; 
    }
}


//点击下一步的响应方法
- (IBAction)didClickNextStepButtonAction:(id)sender {
    if (![_phoneNumTextField.text isValidPhoneNumber]) {
        [self phoneError];
    }else if ([self.passWordTextField.text length] < 6){
        [self showHUDWithText:@"您输入的密码有误"]; return;
    }else{
        
        __weak typeof(self) weakSelf = self;
        MZPhoneValidateParam *param = [[MZPhoneValidateParam alloc] init];
        [param setPhone:self.phoneNumTextField.text];
        param.reset = @"1";
        [self showHoldView];
        [MZRequestManger phoneValidateRequest:param success:^(NSString *object) {
            [weakSelf hideHUD];
            [[UserHelp sharedUserHelper]setUserName:self.phoneNumTextField.text];
            [[UserHelp sharedUserHelper]setPassWord:self.passWordTextField.text];
            [_phoneNumTextField resignFirstResponder];
            [_passWordTextField resignFirstResponder];
            [[UserHelp sharedUserHelper] setMsgCode:object];

            MZRegiSendMessageViewController *regiSendMessageVC = [[MZRegiSendMessageViewController alloc]init];
            regiSendMessageVC.type = MZSendMessageTypePassword;
            regiSendMessageVC.messageCodeString = object;
            [weakSelf.navigationController pushViewController:regiSendMessageVC animated:YES];
            
        } failure:^(NSString *errMsg) {
            [weakSelf hideHUD];
            [weakSelf showHUDWithText:errMsg];
        }];
    }
}

/**
 *  手机号错误提示
 */
-(void)phoneError{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"小图提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alterView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
