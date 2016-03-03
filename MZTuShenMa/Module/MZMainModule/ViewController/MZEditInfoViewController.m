//
//  MZEditInfoViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZEditInfoViewController.h"
#import "MZModifyInfoViewController.h"
#import "PECropViewController.h"
#import "UIImageView+WebCache.h"
#import "MZModifySexViewController.h"
#import "MZUserModel.h"
@interface MZEditInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    UIImage *_image;
    NSString *_filePath;                 // 沙盒中图片的完整路径
    MZUserModel *_userModel;
}

@property (weak, nonatomic) IBOutlet UIView *modifyHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UIView *modifyNameView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *modifySexView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@end

@implementation MZEditInfoViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZEditInfoViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void) setUIDef
{
    self.title = @"编辑资料";
    [self setLeftBarButton];
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    UITapGestureRecognizer *headViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeadViewAction:)];
    [_modifyHeadView addGestureRecognizer:headViewTap];
    
    UITapGestureRecognizer *nameViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickNameViewAction:)];
    [_modifyNameView addGestureRecognizer:nameViewTap];
    
    UITapGestureRecognizer *sexViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickSexViewAction:)];
    [_modifySexView addGestureRecognizer:sexViewTap];
    
    
    
}

- (void)setUser_img:(NSString *)user_img
{
    _user_img = user_img;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
}

//- (void)setUser_name:(NSString *)user_name
//{
//    _user_name = user_name;
//    _nameLabel.text = _user_name;
//}
//
//- (void)setSex:(NSString *)sex
//{
//    _sex = sex;
//    if ([sex isEqualToString:@"1"]) {
//         _sexLabel.text = @"男";
//    }else{
//        _sexLabel.text = @"女";
//    }
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData
{
    MZUserEditParam *userEditParam = [[MZUserEditParam alloc]init];
    userEditParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
        userEditParam.way = phoneNumType;
    }
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        userEditParam.way =wxType;
    }
    [MZRequestManger userEditRequest:userEditParam success:^(NSArray *object) {
        _userModel = [MZUserModel objectWithKeyValues:object];
//        _user_img = _userModel.user_img;
        _nameLabel.text = _userModel.user_name;
        if ([_userModel.sex isEqualToString:@"1"]) {
            _sexLabel.text = @"男";
        }else{
            _sexLabel.text = @"女";
        }
    } failure:^(NSString *errMsg, NSString *errCode) {
        
    }];
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    
}

- (void)didClickHeadViewAction:(UITapGestureRecognizer *)tap
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册选择" otherButtonTitles:@"相机拍摄",nil];
    [actionSheet showInView:self.view];
}

#pragma mark ------- UIActionSheetDelegate
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
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"头像上传失败" message:@"因为一些原因，您的头像上传失败了，您可以稍后尝试或者联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(BOOL)saveHeader:(UIImage *)croppedImage{
    NSData *data;
    if (UIImagePNGRepresentation(croppedImage) != nil)
    {
        data = UIImageJPEGRepresentation(croppedImage, 0.1);
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"发生错误" message:@"图片读取出错" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
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
    
    uploadHeadImParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
        uploadHeadImParam.way = phoneNumType;
    }
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        uploadHeadImParam.way =wxType;
    }
    NSDictionary *dict =[uploadHeadImParam bindRequestParam];
    
    
    //在这里调用上传头像接口
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"userPhoto"
                                fileName:_filePath
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        MZModel *model = [MZModel objectWithKeyValues:responseObject];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:model.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return TRUE;
}

//切割页面选择取消，返回到应用需要贴图的页
-(void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString{
    NSLog(@"请求状态: %@",@"success");
    NSLog(@"状态码: %ld",(long)statusCode);
    NSLog(@"请求响应结果: %@",responseObject);
    NSLog(@"请求响应结果: %@",responseString);
}




- (void)didClickNameViewAction:(UITapGestureRecognizer *)tap
{
    MZModifyInfoViewController *modifyInfoVC =[[MZModifyInfoViewController alloc]init];
    modifyInfoVC.titles = @"昵称";
    modifyInfoVC.textFieldString = _nameLabel.text;
    [self.navigationController pushViewController:modifyInfoVC animated:YES];

}


- (void)didClickSexViewAction:(UITapGestureRecognizer *)tap
{
    MZModifySexViewController *sexVC = [[MZModifySexViewController alloc]init];
    sexVC.sex = _userModel.sex ;
    [self.navigationController pushViewController:sexVC animated:YES];
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
