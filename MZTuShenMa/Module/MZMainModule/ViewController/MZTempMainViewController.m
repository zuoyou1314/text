//
//  MZTempMainViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/8.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZTempMainViewController.h"
#import "MZDrawerView.h"
#import "MZAddPhotoAlbumViewController.h"
#import "MZEditInfoViewController.h"
#import "MZMessageViewController.h"
#import "MZSetViewController.h"
#import "MZFeedbackViewController.h"
#import "MZAboutWeViewController.h"
#import "MZLaunchManager.h"
#import "MZIsAlbumParam.h"
#import "MZCreatedAlbumView.h"
#import "PopoverView.h"
#import "QRCodeReaderViewController.h"
@interface MZTempMainViewController ()<MZDrawerViewDelegate,PopoverViewDelegate,QRCodeReaderDelegate>

@end

@implementation MZTempMainViewController
- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZTempMainViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void) setUIDef
{
    self.title = @"相册";
    [self createBarButtonItem];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([userdefaultsDefine boolForKey:@"firstCreatedAlbumView"] == YES) {
        MZCreatedAlbumView *createAlbumView = [[MZCreatedAlbumView alloc]init];
        createAlbumView.frame = [UIScreen mainScreen].bounds;
        [createAlbumView show];
        [userdefaultsDefine setBool:NO forKey:@"firstCreatedAlbumView"];
    }
}

/**
 *  创建导航栏上面的Item
 */
- (void)createBarButtonItem
{
    UIButton *leftButton = [UIButton createButtonWithNormalImage:@"main_highlight_me" highlitedImage:nil target:self action:@selector(didClickLeftBarAction)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *rightButton = [UIButton createButtonWithNormalImage:@"main_highlight_add" highlitedImage:nil target:self action:@selector(didClickAddButton:)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

#pragma mark -- Event Response
/**
 *  导航栏左边按钮的响应方法
 */
- (void)didClickLeftBarAction
{
    NSLog(@"弹出侧边栏");
    MZDrawerView *drawerView =[[MZDrawerView alloc]init];
    drawerView.frame = [UIScreen mainScreen].bounds;
    drawerView.drawerDelegate = self;
    [drawerView show];
    
}

#pragma mark ----- MZDrawerViewDelegate

- (void)didClickHeadImageAction:(UIImageView *)headImage user_img:(NSString *)user_img user_name:(NSString *)user_name sex:(NSString *)sex
{
    MZEditInfoViewController *editInfoVC = [[MZEditInfoViewController alloc]init];
    editInfoVC.user_img = user_img;
    editInfoVC.user_name = user_name;
    editInfoVC.sex = sex;
    [self.navigationController pushViewController:editInfoVC animated:YES];
}


- (void)didClickCellWithRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            NSLog(@"我的消息");
            MZMessageViewController *messageVC = [[MZMessageViewController alloc]init];
            messageVC.code = @"1";
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"设置");
            MZSetViewController *setVC =[[MZSetViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"APP Store评分");
            NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"954270"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 3:
        {
            NSLog(@"客服与反馈");
            MZFeedbackViewController *feedbackVC = [[MZFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"关于我们");
            MZAboutWeViewController *aboutWeVC = [[MZAboutWeViewController alloc]init];
            [self.navigationController pushViewController:aboutWeVC animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}




- (void)didClickAddButton:(UIButton *)button
{
    CGPoint point =
    CGPointMake(button.frame.origin.x + button.frame.size.width / 2,
                64.0 + 3.0);
    NSArray *titles = @[@"添加相册",@"扫一扫"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point
                                                   titles:titles
                                               imageNames:@[@"main_addAlbum_normal",@"main_qrcode_normal"] highlitedImages:@[@"main_addAlbum_highlited",@"main_qrcode_highlited"]];
    pop.delegate = self;
    [pop show];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

- (void)someMethod
{
    if ([userdefaultsDefine objectForKey:@"user_id"]) {
        __weak typeof(self) weakSelf = self;
        MZIsAlbumParam *isAlbumParam = [[MZIsAlbumParam alloc]init];
        isAlbumParam.user_id =[userdefaultsDefine objectForKey:@"user_id"];
        [self showHoldView];
        [MZRequestManger isAlbumRequest:isAlbumParam success:^(NSString *object) {
            [weakSelf hideHUD];
            if ([object integerValue] == 1) {
                [[MZLaunchManager manager] startApplication];
            }
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
    }
}

#pragma mark - PopoverViewDelegate
- (void)didSelectedRowAtIndex:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"创建相册");
        MZAddPhotoAlbumViewController *addPhotoAlbumVC = [[MZAddPhotoAlbumViewController alloc]init];
        [self.navigationController pushViewController:addPhotoAlbumVC animated:YES];
    } else if (index == 1) {
        NSLog(@"扫一扫");
        // 扫描二维码
        QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
        reader.delegate = self;
        
        __weak typeof (self) wSelf = self;
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            [wSelf.navigationController popViewControllerAnimated:YES];
            
            NSString *heardString;
            if (resultAsString.length>15) {
                heardString = [resultAsString substringToIndex:15];
            }
            if ([heardString isEqualToString:@"http://tushenme"]) {
                
                MZAppAddParam *appAddParam = [[MZAppAddParam alloc]init];
                //从字符A中分隔成2个元素的数组
                NSArray *array = [resultAsString componentsSeparatedByString:@"="];
                appAddParam.album_id = [array objectAtIndex:1];
                //appAddParam.album_id = [resultAsString substringFromIndex:76];
                appAddParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
                
                [MZRequestManger appAddRequest:appAddParam success:^(NSDictionary *object) {
                    UIAlertView *alert;
                    if ([[[object objectForKey:@"errCode"]stringValue]isEqualToString:@"1"]) {
                        alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"您已经加入过相册." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                    }else if ([[[object objectForKey:@"errCode"]stringValue]isEqualToString:@"10010"]){
                        NSLog(@"您的账号被冻结了");
                    }else{
                        alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"加入相册成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                    }
                    [alert show];
                    [[MZLaunchManager manager] startApplication];
                } failure:^(NSString *errMsg, NSString *errCode) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"加入相册失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"注意" message:@"请选择你要加入的相册二维码." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
            }
        }];
        [self.navigationController pushViewController:reader animated:YES];
        //[self presentViewController:reader animated:YES completion:NULL];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
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
