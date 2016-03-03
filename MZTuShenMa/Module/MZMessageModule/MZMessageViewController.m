//
//  MZMessageViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZMessageViewController.h"
#import "MZMessageTableViewCell.h"
#import "MZNewlistsParam.h"
#import "MZNewlistsModel.h"
#import "MZDynamicDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface MZMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_newlistsArray;
    UITableView *_tableView;
}
@end

@implementation MZMessageViewController

static NSString * const messageCellIdentifier = @"messageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    [self setLeftBarButton];
//    [self initUI];
//    [self initData];
}

- (void)initUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0f green:254/255.0f blue:255/255.0f alpha:1.0f];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    //注册标识
    [_tableView registerNib:[UINib nibWithNibName:@"MZMessageTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellIdentifier];

}

- (void)initData
{
    __weak typeof(self) weakSelf = self;
    MZNewlistsParam *newlistsParam = [[MZNewlistsParam alloc]init];
    newlistsParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    newlistsParam.code = self.code;
    [self showHoldView];
    [MZRequestManger newlistsRequest:newlistsParam  success:^(NSArray *object) {
        [weakSelf hideHUD];
        _newlistsArray = [NSMutableArray arrayWithCapacity:object.count];
        for (NSDictionary *dic in object) {
            MZNewlistsModel *dataModel = [MZNewlistsModel objectWithKeyValues:dic];
            [_newlistsArray addObject:dataModel];
        }
        [_tableView reloadData];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];

}

#pragma mark ----- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newlistsArray.count;
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
    MZNewlistsModel *dataModel = [_newlistsArray objectAtIndex:indexPath.row];
    MZMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier forIndexPath:indexPath];
    messageCell.model = dataModel;
    return messageCell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
////    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
//    
//    MZNewlistsModel *dataModel = [_newlistsArray objectAtIndex:indexPath.row];
//    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
//    dynamicDetailVC.album_id = dataModel.album_id;
////    dynamicDetailVC.album_name = _album_name;
//    dynamicDetailVC.issue_id = dataModel.photo_id;
//    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
//
//}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.code isEqualToString:@"0"]) {
        NSLog(@"0：新消息 ");
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"新消息页"];
    }else{
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"我的消息页"];
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.code isEqualToString:@"0"]) {
        NSLog(@"0：新消息 ");
        [[BaiduMobStat defaultStat] pageviewEndWithName:@"新消息页"];
    }else{
        [[BaiduMobStat defaultStat] pageviewEndWithName:@"我的消息页"];
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
