//
//  MZSetViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/30.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZSetViewController.h"
#import "MZBlacklistViewController.h"
#import "MZLaunchManager.h"
#import "MZForgetPasswordViewController.h"
#import "MZQuitLoginParam.h"
#define kCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]
//计算Caches路径下的缓存大小
#define kSizeAtPath [self folderSizeAtPath:kCachesDirectory]

@interface MZSetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSIndexPath *_firstIndexPath;
    UITableView *_tableView;
    UIAlertView * _alert;
}
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exitButtonTop;

@end

@implementation MZSetViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZSetViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void)setUIDef
{
    
    [self setLeftBarButton];
    self.title = @"设置";
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
//    _exitButton.layer.borderColor = [UIColorFromRGB(0x308afc)CGColor];
//    _exitButton.layer.borderWidth= 1.0f;
//    _exitButton.layer.cornerRadius = 25;
//    _exitButton.layer.masksToBounds = YES;
    
    
    
    
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        _tableView = [[UITableView alloc]initWithFrame:rect(0.0f, 64.0f, SCREEN_WIDTH,45.0f) style:UITableViewStylePlain];
        _exitButtonTop.constant = 150;
    }else{
        _tableView = [[UITableView alloc]initWithFrame:rect(0.0f, 64.0f, SCREEN_WIDTH,90.0f) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    //自定义header颜色
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    

//    _tableView.sectionFooterHeight = 0;
//    
//    [[UITableViewHeaderFooterView appearance] setTintColor:UIColorFromRGB(0xf4f4f4)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//退出按钮的响应方法
- (IBAction)didClickExitButtonAction:(id)sender {
    NSLog(@"退出账户");
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下次你需要重新登录,确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        //退出登录
        MZQuitLoginParam *quitLoginParam = [[MZQuitLoginParam alloc]init];
        quitLoginParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        [MZRequestManger quitLoginRequest:quitLoginParam success:^(NSDictionary *object) {
            
        } failure:^(NSString *errMsg, NSString *errCode) {
            
        }];
        [[MZLaunchManager manager] logoutScreen];
        [[MZLaunchManager manager] logout];
    }
}


#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        return 1;
    }else{
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        return 1;
    }else{
        return 2;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10.0f;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 200.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc]initWithFrame:rect(0,0,SCREEN_WIDTH,200)];
//    footView.backgroundColor = [UIColor redColor];
//    return footView;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        NSArray *nameArray = @[@"清理缓存"];
        NSArray *detailTextArray = @[[NSString stringWithFormat:@"%.2fMB",kSizeAtPath]];
        cell.textLabel.text = nameArray[indexPath.section];
        cell.detailTextLabel.text = detailTextArray[indexPath.section];
    }else{
        NSArray *nameArray = @[@"登录密码",@"清理缓存"];
        NSArray *detailTextArray = @[@"更改",[NSString stringWithFormat:@"%.2fMB",kSizeAtPath]];
        cell.textLabel.text = nameArray[indexPath.row];
        cell.detailTextLabel.text = detailTextArray[indexPath.row];
        if (indexPath.row == 0) {
            UIView *segmentLine = [[UIView alloc]initWithFrame:rect(0.0f,45.0f,SCREEN_WIDTH,0.5)];
            segmentLine.backgroundColor = RGB(240, 240, 240);
            [cell addSubview:segmentLine];
        }else{
            UIView *segmentLine = [[UIView alloc]initWithFrame:rect(0.0f,0.0f,SCREEN_WIDTH,0.5)];
            segmentLine.backgroundColor = RGB(240, 240, 240);
            [cell addSubview:segmentLine];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableDictionary *dic = [typeArray objectAtIndex:indexPath.section];
//    NSMutableDictionary *infoDic = [dic objectForKey:@"dic"];
//    if (indexPath.row==[infoDic count]-1) {
//        NSLog(@"indexPath.row===%d",indexPath.row);
//        cell.separatorInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//else if (indexPath.section == 1){
//    NSLog(@"我的黑名单");
//    MZBlacklistViewController *blacklistVC =[[MZBlacklistViewController alloc]init];
//    [self.navigationController pushViewController:blacklistVC animated:YES];
//}
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; （这种是没有点击后的阴影效果)
    
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;  //（这种是点击的时候有效果，返回后效果消失）
    
    
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
         [self clearWithRowAtIndexPath:indexPath];
    }else{
        if (indexPath.row == 0) {
            NSLog(@"更改登陆密码");
            MZForgetPasswordViewController *forgetPasswordVC = [[MZForgetPasswordViewController alloc]init];
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [self.navigationController pushViewController:forgetPasswordVC animated:YES];
        }else{
            NSLog(@"清理缓存");
            [self clearWithRowAtIndexPath:indexPath];
        }

    }
}


- (void)clearWithRowAtIndexPath:(NSIndexPath *)indexPath{
    _firstIndexPath = indexPath;
    _alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"正在瘦身....." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [_alert show];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    //    MDWSetTableViewCells *cell = (MDWSetTableViewCells *)[_tableView cellForRowAtIndexPath:_firstIndexPath];
    //    cell.numberLabel.text = [NSString stringWithFormat:@"(%.2fM)",kSizeAtPath];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_firstIndexPath];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%.2fM)",kSizeAtPath];
    [_alert dismissWithClickedButtonIndex:0 animated:NO];
}

//计算某个路径下的缓存大小
- (float ) folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//计算某个文件的缓存大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
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
