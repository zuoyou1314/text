//
//  MZDrawerVIew.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/29.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDrawerView.h"
#import "MZUserEditParam.h"
#import "MZRequestManger+User.h"
#import "MZUserModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MZDrawerTableViewCell.h"
@interface MZDrawerView ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    MZUserModel *_userModel;
    UITableView *_tableView;
}

@property (weak, nonatomic) IBOutlet UIView *customDrawerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end


@implementation MZDrawerView

static NSString * const drawerTableViewCellIdentifier = @"drawerCell";

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MZDrawerView" owner:self options:nil] lastObject];
        [self initData];
        [self setUIDef];
        
    }
    return self;
}

- (void)setUIDef
{
    _lineHeight.constant = 0.5f;
    
    _headImage.layer.cornerRadius = CGRectGetHeight(_headImage.bounds)/2;
    _headImage.layer.masksToBounds = YES;
    //修改头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickHeadImageAction:)];
    _headImage.userInteractionEnabled = YES;
    [_headImage addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(_lineView.frame.origin.x,_lineView.frame.origin.y +_lineView.frame.size.height, 150.0f, 225.0f-45.0f) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_customDrawerView addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    //注册标识
    [_tableView registerNib:[UINib nibWithNibName:@"MZDrawerTableViewCell" bundle:nil] forCellReuseIdentifier:drawerTableViewCellIdentifier];
    
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
        [_headImage sd_setImageWithURL:[NSURL URLWithString:_userModel.user_img] placeholderImage:[UIImage imageNamed:@"main_backImage"]];
        _nameLabel.text = _userModel.user_name;
        [_tableView reloadData];
    } failure:^(NSString *errMsg, NSString *errCode) {
        
    }];

}

#pragma mark ------ Event Action
- (void)didClickHeadImageAction:(UITapGestureRecognizer *)tap
{
    _headImage = (UIImageView *)tap.view;
    NSLog(@"修改头像");
    if (_drawerDelegate  &&[_drawerDelegate respondsToSelector:@selector(didClickHeadImageAction:user_img:user_name:sex:)]) {
        [_drawerDelegate  didClickHeadImageAction:_headImage user_img:_userModel.user_img user_name:_userModel.user_name sex:_userModel.sex];
    }
}


- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.backgroundColor = RGBA(0, 0, 0, 0.1);
    _customDrawerView.frame = CGRectMake(-190, 0, 190, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.5 animations:^{
          self.backgroundColor = RGBA(0, 0, 0, 0.4);
          _customDrawerView.frame = CGRectMake(0, 0, 190, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.1);
        _customDrawerView.frame = CGRectMake(-190, 0, 190, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
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
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *nameArray = @[@"我的消息",@"设置",@"APP Store评分",@"客服与反馈",@"关于我们"];
    NSArray *nameArray = @[@"设置",@"APP Store评分",@"客服与反馈",@"关于我们"];
//    NSArray *headArray = @[@"main_myMessage",@"main_set",@"main_appComment",@"main_ service",@"main_aboutwe"];
    NSArray *headArray = @[@"main_set",@"main_appComment",@"main_ service",@"main_aboutwe"];
    MZDrawerTableViewCell *drawerCell = [tableView dequeueReusableCellWithIdentifier:drawerTableViewCellIdentifier forIndexPath:indexPath];
    drawerCell.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    drawerCell.contentLabel.text = [nameArray objectAtIndex:indexPath.row];
    drawerCell.headImage.image = [UIImage imageNamed: [headArray objectAtIndex:indexPath.row]];
    //点击cell颜色
    drawerCell.selectedBackgroundView = [[UIView alloc] initWithFrame:drawerCell.frame];
    drawerCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:33.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    return drawerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
    //    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    [self dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_drawerDelegate  &&[_drawerDelegate respondsToSelector:@selector(didClickCellWithRow:)]) {
            [_drawerDelegate  didClickCellWithRow:indexPath.row+1];
        }
    });
    

    
    
}


@end
