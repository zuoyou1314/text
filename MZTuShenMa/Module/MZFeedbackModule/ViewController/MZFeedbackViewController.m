//
//  MZFeedbackViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/30.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZFeedbackViewController.h"
#import "MZFeedbackParam.h"
@interface MZFeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneTextView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation MZFeedbackViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZFeedbackViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    self.title = @"意见与反馈";
    [self  setLeftBarButton];
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);

    //修改导航栏按钮的颜色
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = rect(0, 0, 35, 35);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didClickRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:UIColorFromRGB(0x308afc) forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;


    
    _feedbackTextView.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _feedbackTextView.layer.borderWidth= 1.0f;
    _feedbackTextView.layer.cornerRadius = 8;
    _feedbackTextView.delegate = self;
    _feedbackTextView.layer.masksToBounds = YES;
    
    
    _phoneTextView.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f]CGColor];
    _phoneTextView.layer.borderWidth= 1.0f;
    _phoneTextView.layer.cornerRadius = 8;
    _phoneTextView.delegate = self;
    _phoneTextView.layer.masksToBounds = YES;
    
    
}


#pragma mark ------UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    _feedbackLabel.text = textView.text;
    _phoneLabel.text = textView.text;
    
    if (textView.text.length == 0) {
        _feedbackLabel.text = @"在这里填写图什么的意见,我们将不断的改进,感谢您的支持!";
        _phoneLabel.text = @"手机或QQ (选填)";
    }else if(_feedbackTextView.text.length!= 0 && _phoneTextView.text.length == 0 ){
        _feedbackLabel.text = @"";
        _phoneLabel.text = @"手机或QQ (选填)";
    }else if (_phoneTextView.text.length != 0 && _feedbackTextView.text.length == 0){
        _phoneLabel.text = @"";
        _feedbackLabel.text = @"在这里填写图什么的意见,我们将不断的改进,感谢您的支持!";
    }else{
        _feedbackLabel.text = @"";
        _phoneLabel.text = @"";
    }
    
}
#pragma end ------UITextViewDelegate


- (void)didClickRightBarItem
{
    NSLog(@"发送");
    
    if ([_feedbackTextView.text length] == 0 || [[_feedbackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"意见与反馈不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
    }else{
        
    __weak typeof(self) weakSelf = self;
    MZFeedbackParam *feedbackParam = [[MZFeedbackParam alloc]init];
    feedbackParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    feedbackParam.fank = _feedbackTextView.text;
    NSLog(@"_phoneTextView.text == %@",_phoneTextView.text);
    feedbackParam.contact =_phoneTextView.text;
    [self showHoldView];
    [MZRequestManger fankRequest:feedbackParam success:^(NSDictionary *object) {
          [weakSelf hideHUD];
          [self sendSuccess];
    } failure:^(NSString *errMsg, NSString *errCode) {
          [weakSelf hideHUD];
        if (![errMsg isEqualToString:@"账号冻结"]) {
            [self sendFailure];
        }
    } ];
        
    }
    

}

#pragma mark -- Private Method
/**
 *  发送成功提示
 */
-(void)sendSuccess{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的反馈" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alterView show];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  发送失败提示
 */
-(void)sendFailure{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败，请稍后再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alterView show];
}


///**
// *  空内容提示
// */
//-(void)sendNilContentFailure{
//    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"您似乎忘记填写反馈意见。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [alterView show];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_feedbackTextView resignFirstResponder];
    [_phoneTextView resignFirstResponder];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
