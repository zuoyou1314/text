//
//  MZModifySexViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZModifySexViewController.h"
#import "MZEditInfoViewController.h"
@interface MZModifySexViewController ()
@property (weak, nonatomic) IBOutlet UIView *manView;
@property (weak, nonatomic) IBOutlet UILabel *manLabel;

@property (weak, nonatomic) IBOutlet UIView *womenView;
@property (weak, nonatomic) IBOutlet UILabel *womenLabel;

@end

@implementation MZModifySexViewController
- (instancetype)init
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZModifySexViewController" owner:self options:nil] lastObject];
        [self setUIDef];
    }
    return self;
}

- (void) setUIDef
{
    self.title = @"性别";
    [self setLeftBarButton];
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    UITapGestureRecognizer *manViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickManViewAction:)];
    [_manView addGestureRecognizer:manViewTap];
    
    UITapGestureRecognizer *womenViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickWomenViewAction:)];
    [_womenView addGestureRecognizer:womenViewTap];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = rect(0, 0, 35, 35);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didClickRightBarItemAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:UIColorFromRGB(0x308afc) forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)didClickRightBarItemAction
{
    __weak typeof(self) weakSelf = self;
    MZUserFillParam *userFillParam = [[MZUserFillParam alloc]init];
    userFillParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"1"]) {
        userFillParam.way = phoneNumType;
    }
    if ([[userdefaultsDefine objectForKey:@"way"]isEqualToString:@"3"]) {
        userFillParam.way =wxType;
    }
    if ([_manLabel.text isEqualToString:@"√"]) {
        userFillParam.sex = @"1";
    }
    if ([_womenLabel.text isEqualToString:@"√"]) {
        userFillParam.sex = @"2";
    }
    [self showHoldView];
    [MZRequestManger UserFillRequest:userFillParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];

}


- (void)setSex:(NSString *)sex
{
    _sex = sex;
    if ([sex isEqualToString:@"1"]) {
        _manLabel.text = @"√";
        _womenLabel.text = @"";
    }else{
        _manLabel.text = @"";
        _womenLabel.text = @"√";
    }
}



- (void)didClickManViewAction:(UITapGestureRecognizer *)tap
{
    _manLabel.text = @"√";
    _womenLabel.text = @"";
    
}

- (void)didClickWomenViewAction:(UITapGestureRecognizer *)tap
{
    _manLabel.text = @"";
    _womenLabel.text = @"√";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
