//
//  MZAddFriendViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAddFriendViewController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
@interface MZAddFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation MZAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加成员";
    [self setNavigationDefaultLeftBarButton];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10.0f, SCREEN_WIDTH, 60.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *imageArray = @[@"main_head",@"main_head",@"main_head"];
//    NSArray *nameArray = @[@"通讯录好友",@"QQ好友",@"微信好友"];
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"wx"];
    cell.imageView.layer.cornerRadius = CGRectGetHeight([cell.imageView frame])/2;
    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = @"微信好友";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        NSLog(@"跳转通讯录好友");
//    }else if (indexPath.row == 1){
//        NSLog(@"跳转QQ好友");
//    }else{
        NSLog(@"跳转微信好友");
//    }
    
    UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
    [socialControllerService setShareText:@"和你的朋友一起玩的相册" shareImage:[UIImage imageNamed:@"main_backImage"] socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,socialControllerService,YES);
}

//tableview分割线缺少15像素
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
