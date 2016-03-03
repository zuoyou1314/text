//
//  MZAddPhotoAlbumViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAddPhotoAlbumViewController.h"
#import "MZCreateAlbumParam.h"
#import "MZRequestManger+User.h"
#import "MZMainViewController.h"
#import "MZLaunchManager.h"
#import "MZTempMainViewController.h"
#import "MZBaseNavigationViewController.h"
#define MaxNumberOfDescriptionChars  10
@interface MZAddPhotoAlbumViewController ()
@property (weak, nonatomic) IBOutlet UITextField *photoAlbumNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *photoAlbumDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@end

@implementation MZAddPhotoAlbumViewController


- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZAddPhotoAlbumViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    self.title = @"相册";
    
     [self  setLeftBarButton];
    
    _photoAlbumDetailTextView.layer.borderColor = [[UIColor colorWithRed:194.0f/255.0f green:195.0f/255.0f blue:196.0f/255.0f alpha:1.0f] CGColor];
    _photoAlbumDetailTextView.layer.borderWidth= 1.0f;
    _photoAlbumDetailTextView.layer.cornerRadius = 8;
    _photoAlbumDetailTextView.layer.masksToBounds = YES;
    
    
    _sendButton.layer.cornerRadius = 25;
    _sendButton.layer.masksToBounds = YES;
    
    _sendButton.hidden = YES;
    
    //修改导航栏按钮的颜色
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = rect(0, 0, 35, 35);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didClickRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:UIColorFromRGB(0x308afc) forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:_photoAlbumNameTextField];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_photoAlbumDetailTextView resignFirstResponder];
    [_photoAlbumNameTextField resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self initUI];
}

- (void)initUI
{
//    self.view.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:253.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
}


- (void)didClickRightBarItem
{
//    if ([_photoAlbumNameTextField.text length] < 2  ){
//        [self showHUDWithText:@"您输入的相册名称过短"]; return;
//    }else if([_photoAlbumNameTextField.text length]>10){
//        [self showHUDWithText:@"您输入的相册名称过长"]; return;
//    }else{
    
    if ([_photoAlbumNameTextField.text length] == 0 || [[_photoAlbumNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"相册名称不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
//    }else
//        if ([_photoAlbumDetailTextView.text length] == 0){
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"相册描述不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        [alertView show];
    }else{
        __weak typeof(self) weakSelf = self;
        MZCreateAlbumParam *createAlbumParam = [[MZCreateAlbumParam alloc]init];
        createAlbumParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        
        createAlbumParam.album_name = _photoAlbumNameTextField.text;
        createAlbumParam.album_des = _photoAlbumDetailTextView.text;
        [self showHoldView];
        [MZRequestManger createAlbumRequest:createAlbumParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            MZTempMainViewController *tempMainVC = [[MZTempMainViewController alloc]init];
            MZBaseNavigationViewController *mzBaseNC = [[MZBaseNavigationViewController alloc]initWithRootViewController:tempMainVC];
            if ([self getAppDelegate].window.rootViewController==mzBaseNC) {
                [[MZLaunchManager manager] startApplication];
            }else{
                MZMainViewController *mainVC = [[MZMainViewController alloc]init];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
    }
    
       //    }

}

//- (IBAction)didClickSendButtonAction:(id)sender {
//    
//    if ([_photoAlbumNameTextField.text length] < 2  ){
//        [self showHUDWithText:@"您输入的相册名称过短"]; return;
//    }else if([_photoAlbumNameTextField.text length]>10){
//        [self showHUDWithText:@"您输入的相册名称过长"]; return;
//    }else{
//        __weak typeof(self) weakSelf = self;
//        MZCreateAlbumParam *createAlbumParam = [[MZCreateAlbumParam alloc]init];
//        createAlbumParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
//        createAlbumParam.album_name = _photoAlbumNameTextField.text;
//        createAlbumParam.album_des = _photoAlbumDetailTextView.text;
//        [self showHoldView];
//        [MZRequestManger createAlbumRequest:createAlbumParam success:^(NSDictionary *object) {
//            [weakSelf hideHUD];
//            MZTempMainViewController *tempMainVC = [[MZTempMainViewController alloc]init];
//            MZBaseNavigationViewController *mzBaseNC = [[MZBaseNavigationViewController alloc]initWithRootViewController:tempMainVC];
//            if ([self getAppDelegate].window.rootViewController==mzBaseNC) {
//                [[MZLaunchManager manager] startApplication];
//            }else{
//                MZMainViewController *mainVC = [[MZMainViewController alloc]init];
//                [self.navigationController pushViewController:mainVC animated:YES];
//            }
//        } failure:^(NSString *errMsg, NSString *errCode) {
//            [weakSelf hideHUD];
//        }];
//    }
//}


-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = _photoAlbumNameTextField.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > MaxNumberOfDescriptionChars) {
                textField.text = [toBeString substringToIndex:MaxNumberOfDescriptionChars];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > MaxNumberOfDescriptionChars) {
            textField.text = [toBeString substringToIndex:MaxNumberOfDescriptionChars];
        }
    }
}


//去掉字符串两端的空格及回车
- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    return text;
}



- (AppDelegate *)getAppDelegate
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate);
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
