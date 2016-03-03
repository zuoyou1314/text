//
//  MZPrintUserInfoViewController.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPrintUserInfoViewController.h"
#import "PECropViewController.h"
#import "UIImageView+WebCache.h"
#import "MZUserFillParam.h"
#import "MZLaunchManager.h"
NS_ENUM(NSInteger, sexTag)
{
    man = 99,
    woman = 999
};

@interface MZPrintUserInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    UIImage *_image;
    NSString *_filePath;
    NSString *_sex;
    NSUInteger _maxNumberOflength;
    NSUInteger _maxChineselangNumberOflength;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;



@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@end

@implementation MZPrintUserInfoViewController

- (instancetype)init
{
    if(self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZPrintUserInfoViewController" owner:self options:nil] lastObject];
//        [self.commitButton.layer setCornerRadius:22.5f];
        self.title = @"填写资料";
        [self setNavigationItem];
        
        [self.infoView.layer setCornerRadius:1.5];
        self.infoView.layer.masksToBounds = YES;
        [self.commitButton.layer setCornerRadius:1.5];
        self.commitButton.layer.masksToBounds = YES;
        
        
        
        [self.userNameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:_userNameTextField];

        
        _headImage.layer.cornerRadius = CGRectGetWidth(_headImage.bounds)/2;
        _headImage.layer.masksToBounds = YES;
        _headImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeadImageAction)];
        [_headImage addGestureRecognizer:tap];
        
        _sex = [NSString string];
        
    }
    return self;
}


//点击头像响应方法
- (void)didClickHeadImageAction
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册选择" otherButtonTitles:@"相机拍摄",nil];
    [actionSheet showInView:self.view];
}

#pragma mark ----UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self photoAction];
            break;
        case 1:
            [self carameAction];
            break;
        case 2:
            [self cancelAction];
            break;
    }
}

//选择相册
-(void)photoAction{
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
    imagePickerController.delegate= self;
    imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

//选择相机拍摄
-(void)carameAction{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
        picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //如果当前设备没有摄像头
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备没有摄像头 " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
//选择取消
-(void)cancelAction{
    
}

#pragma mark ----UIImagePickerControllerDelegate

//相册选择图片或拍照完成后调用
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _image=info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor];
    }];
}

//打开切割页面
-(void)openEditor{
    PECropViewController *cropViewController=[[PECropViewController alloc] init];
    cropViewController.image=_image;
    //    cropViewController.toolbarHidden = YES;
    cropViewController.delegate=self;
    CGFloat width = _image.size.width;
    CGFloat height = _image.size.height;
    CGFloat length = MIN(width, height);
    cropViewController.imageCropRect = CGRectMake((width - length) / 2,(height - length) / 2,length,length);
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cropViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

//从切割页面返回时调用，将切完的图放在某个位置上
-(void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    if ([self saveHeader:croppedImage]) {
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"头像上传失败" message:@"因为一些原因，您的头像上传失败了，您可以稍后尝试或者联系客服" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


-(BOOL)saveHeader:(UIImage *)croppedImage{
    NSData *data;
    if (UIImagePNGRepresentation(croppedImage) != nil)
    {
        data = UIImageJPEGRepresentation(croppedImage, 0.1);
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"发生错误" message:@"图片读取出错" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    if([fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil]){
        if ([fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil]) {
            
        }else{
            return FALSE;
        }
    }else{
        return FALSE;
    }
    //得到选择后沙盒中图片的完整路径
    _filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/image.png"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如果报接受类型不一致请替换一致text/html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@:%@/%@",kHost,kPort,kUploadHeadimg];
    
    MZUploadHeadImgParam *uploadHeadImParam = [[MZUploadHeadImgParam alloc]init];
    
    uploadHeadImParam.user_id = self.user_id;
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
        uploadHeadImParam.way = phoneNumType;
    }
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        uploadHeadImParam.way =wxType;
    }
    NSLog(@"uploadHeadImParam.way = %ld",uploadHeadImParam.way);
    NSDictionary *dict =[uploadHeadImParam bindRequestParam];
    
    
    //在这里调用上传头像接口
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"userPhoto"
                                fileName:_filePath
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
        
        if ([response.errCode isEqualToString:@"10010"]) {
            [self showHUDWithText:response.errMsg];
        }
     
        [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString];
        MZModel *model = [MZModel objectWithKeyValues:responseObject];
//        NSLog(@"model.user_img = %@",model.user_img);
        [_headImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
   
    }];
    
    return TRUE;
}

-(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString{
    NSLog(@"请求状态: %@",@"success");
    NSLog(@"状态码: %ld",(long)statusCode);
    NSLog(@"请求响应结果: %@",responseObject);
    NSLog(@"请求响应结果: %@",responseString);
}

//切割页面选择取消，返回到应用需要贴图的页
-(void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


//提交
- (IBAction)commitButtonTouchUpInside:(id)sender
{
    __weak typeof(self) weakSelf = self;
    MZUserFillParam *userFillParam = [[MZUserFillParam alloc]init];
    userFillParam.user_id = self.user_id;
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
        userFillParam.way = phoneNumType;
    }
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        userFillParam.way =wxType;
    }
    
    
    if ([_userNameTextField.text length] < 1  ){
        [self showHUDWithText:@"您输入昵称过短"]; return;
    }else if ([MZPrintUserInfoViewController stringContainsEmoji:_userNameTextField.text] == YES || [[_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0 ){
        [self showHUDWithText:@"请输入正确的（中文、字母、数字）昵称"]; return;
    }else{
    userFillParam.user_name = _userNameTextField.text;
    userFillParam.sex = _sex;
    [self showHoldView];
    [MZRequestManger UserFillRequest:userFillParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        NSLog(@"object = %@",object);
        [userdefaultsDefine setObject:[object objectForKey:@"user_id"] forKey:@"user_id"];
        [userdefaultsDefine setObject:[object objectForKey:@"way"] forKey:@"way"];
        [[MZLaunchManager manager] startApplication];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
        [self showHUDWithText:errMsg];
    }];
        
    }
}

//选择性别
- (IBAction)sexSelectButtonTouchUpInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button viewWithTag:man]) {
        [button setImage:[UIImage imageNamed:@"login_manHighlighted"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"login_ womanNormal"] forState:UIControlStateNormal];
        _sex = @"1";
    }

//    else{
//        [button setImage:[UIImage imageNamed:@"login_manNormal"] forState:UIControlStateNormal];
//    }
    
    if ([button viewWithTag:woman]) {
        [button setImage:[UIImage imageNamed:@"login_ womanHighlighted"] forState:UIControlStateNormal];
        [_manButton setImage:[UIImage imageNamed:@"login_ womanNormal"] forState:UIControlStateNormal];
        _sex = @"2";
    }
    
//    else{
//        [button setImage:[UIImage imageNamed:@"login_ womanNormal"] forState:UIControlStateNormal];
//    }
    
    
    
//    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//    {
//        if((obj && [obj isKindOfClass:[UIButton class]] && ([(UIButton *)obj tag] == man)) || [(UIButton *)obj tag] == woman)
//        {
//            [(UIButton *)obj setSelected:NO];
//        }
//    }];
//    [(UIButton *)sender setSelected:YES];
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextField resignFirstResponder];
}

- (void) setNavigationItem
{
    [self setNavigationDefaultLeftBarButton];
}


#pragma mark ---- 私有方法
-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    _maxNumberOflength = 15;
    _maxChineselangNumberOflength = 10;
    if ([self isChinesecharacter:toBeString]== YES && toBeString.length > _maxChineselangNumberOflength ) {
        textField.text = [toBeString substringToIndex:_maxChineselangNumberOflength];
    }
    
    if ([self isChinesecharacter:toBeString] == NO && toBeString.length > _maxNumberOflength) {
        textField.text = [toBeString substringToIndex:_maxNumberOflength];
    }
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





@end
