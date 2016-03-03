//
//  MZBlacklistViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/30.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBlacklistViewController.h"
#import "MZBlacklistTableViewCell.h"

@interface MZBlacklistViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MZBlacklistViewController

static NSString * const blacklistCellIdentifier = @"blacklistCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"黑名单";
    [self setNavigationDefaultLeftBarButton];
    [self initUI];
    // Do any additional setup after loading the view.
  
    
}

- (void)initUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc]init];
    
    //注册标识
    [tableView registerNib:[UINib nibWithNibName:@"MZBlacklistTableViewCell" bundle:nil] forCellReuseIdentifier:blacklistCellIdentifier];
}

#pragma mark ----- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZBlacklistTableViewCell *blacklistCell = [tableView dequeueReusableCellWithIdentifier:blacklistCellIdentifier forIndexPath:indexPath];
    return blacklistCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
//    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
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
