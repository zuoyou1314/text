//
//  MZModifyInfoViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZModifyInfoViewController.h"
#import "MZEditAlbumParam.h"
#import "MZMainViewController.h"
#define MaxNumberOfDescriptionChars  10
@interface MZModifyInfoViewController ()<UITextFieldDelegate>
{
    NSUInteger _maxNumberOflength;
    NSUInteger _maxChineselangNumberOflength;
}
@property (weak, nonatomic) IBOutlet UITextField *modifyInfoTextField;

@end

@implementation MZModifyInfoViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZModifyInfoViewController" owner:self options:nil] lastObject];
        [self setUIDef];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    return self;
}

- (void) setUIDef
{
    [self setLeftBarButton];
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    //修改导航栏按钮的颜色
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = rect(0, 0, 35, 35);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didClickRightBarItemAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:UIColorFromRGB(0x308afc) forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    
    [_modifyInfoTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:_modifyInfoTextField];
    
 
    

}

- (void)didClickRightBarItemAction
{
    __weak typeof(self) weakSelf = self;
    if ([self.titles isEqualToString:@"昵称"]) {
        
        if ([_modifyInfoTextField.text length] < 1  ){
            [self showHUDWithText:@"您输入昵称过短"]; return;
        }else if ([MZModifyInfoViewController stringContainsEmoji:_modifyInfoTextField.text] == YES || [[_modifyInfoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0 ){
              [self showHUDWithText:@"请输入正确的（中文、字母、数字）昵称"]; return;
        }else{
            MZUserFillParam *userFillParam = [[MZUserFillParam alloc]init];
            userFillParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
                userFillParam.way = phoneNumType;
            }
            if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
                userFillParam.way =wxType;
            }
            userFillParam.user_name = _modifyInfoTextField.text;
            [self showHoldView];
            [MZRequestManger UserFillRequest:userFillParam success:^(NSDictionary *object) {
                [weakSelf hideHUD];
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errMsg, NSString *errCode) {
                [weakSelf hideHUD];
            }];
        }

    }
    
    
      MZEditAlbumParam *editAlbumParam = [[MZEditAlbumParam alloc]init];
      editAlbumParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
      editAlbumParam.album_id = self.album_id;
    if ([self.titles isEqualToString:@"相册名称"]) {
        if ([[_modifyInfoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0 ) {
             [self showHUDWithText:@"相册名称不能为空"]; return;
        }else if ([_modifyInfoTextField.text length] < 2){
            [self showHUDWithText:@"您输入的相册名称过短"]; return;
        }else if([_modifyInfoTextField.text length]>10){
             [self showHUDWithText:@"您输入的相册名称过长"]; return;
        }else{
            editAlbumParam.album_name =_modifyInfoTextField.text;
            [self showHoldView];
            [MZRequestManger editAlbumRequest:editAlbumParam success:^(NSDictionary *object) {
                [weakSelf hideHUD];
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errMsg, NSString *errCode) {
                [weakSelf hideHUD];
            }];
        }
        
    }
    
    if ([self.titles isEqualToString:@"我在本群的昵称"]) {
        
        if ([_modifyInfoTextField.text length] < 1  ){
            [self showHUDWithText:@"您输入昵称过短"]; return;
        }else{
            editAlbumParam.uname =_modifyInfoTextField.text;
            [self showHoldView];
            [MZRequestManger editAlbumRequest:editAlbumParam success:^(NSDictionary *object) {
                [weakSelf hideHUD];
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    return ;
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errMsg, NSString *errCode) {
                [weakSelf hideHUD];
            }];
        }
      
    }
    
    
    if ([self.titles isEqualToString:@"相册描述"]) {
        editAlbumParam.album_des =_modifyInfoTextField.text;
        NSLog(@"editAlbumParam.album_des == %@",editAlbumParam.album_des);
        [self showHoldView];
        [MZRequestManger editAlbumRequest:editAlbumParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
            if ([response.errMsg isEqualToString:@"账号冻结"]) {
                return ;
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
    }
    
}


- (void)setTitles:(NSString *)titles
{
    _titles = titles;
    self.title = _titles;
}

- (void)setTextFieldString:(NSString *)textFieldString
{
    _textFieldString = textFieldString;
    _modifyInfoTextField.text = textFieldString;

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.modifyInfoTextField resignFirstResponder];
}


-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if ([self.titles isEqualToString:@"昵称"] || [self.titles isEqualToString:@"我在本群的昵称"]) {
        _maxNumberOflength = 15;
        _maxChineselangNumberOflength = 10;
        if ([self isChinesecharacter:toBeString]== YES && toBeString.length > _maxChineselangNumberOflength ) {
            textField.text = [toBeString substringToIndex:_maxChineselangNumberOflength];
        }
        
        if ([self isChinesecharacter:toBeString] == NO && toBeString.length > _maxNumberOflength) {
            textField.text = [toBeString substringToIndex:_maxNumberOflength];
        }
    }
    
    if ([self.titles isEqualToString:@"相册名称"]) {
        _maxNumberOflength = 10;
        _maxChineselangNumberOflength = 10;
        if ([self isChinesecharacter:toBeString]== YES && toBeString.length > _maxChineselangNumberOflength ) {
            textField.text = [toBeString substringToIndex:_maxChineselangNumberOflength];
        }
        
        if ([self isChinesecharacter:toBeString] == NO && toBeString.length > _maxNumberOflength) {
            textField.text = [toBeString substringToIndex:_maxNumberOflength];
        }
        
    }

    
//    UITextField *textField = (UITextField *)obj.object;
//    NSString *toBeString = textField.text;
//    NSString *lang = _modifyInfoTextField.textInputMode.primaryLanguage; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > _maxChineselangNumberOflength) {
//                textField.text = [toBeString substringToIndex:_maxChineselangNumberOflength];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//            
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        if (toBeString.length > _maxNumberOflength) {
//            textField.text = [toBeString substringToIndex:_maxNumberOflength];
//        }
//    }
}


//判断是否为汉字
- (BOOL)isChinesecharacter:(NSString *)string{
    if (string.length == 0) {
        return NO;
    }
    unichar c = [string characterAtIndex:0];
    
    if (c >=0x4E00 && c <=0x9FA5){
        return YES;//汉字
    }else{
        return NO;//英文
}}


//计算汉字的个数
- (NSInteger)chineseCountOfString:(NSString *)string{
    int ChineseCount = 0;
    if (string.length == 0) {
        return 0;
    }
    for (int i = 0; i<string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5){
            ChineseCount++ ;//汉字
        }    }
    return ChineseCount;
}


//计算字母的个数
- (NSInteger)characterCountOfString:(NSString *)string{
    int characterCount = 0;
    if (string.length == 0){
        return 0;
    }
    for (int i = 0; i<string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5)        {
        }else{
            characterCount++;//英文
        }}
    return characterCount;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [_modifyInfoTextField resignFirstResponder];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//判断用户是否输入了Emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}


//检测是否包含特殊字符
- (BOOL)isIncludeLegalCharact:(NSString *)str
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [str rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        NSLog(@"包含特殊字符");
        return YES;
    }else{
        return NO;
    }
    
//    if (userNameRange.location == NSNotFound)
//    {
//        return NO;
//    }
//    return YES;

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
