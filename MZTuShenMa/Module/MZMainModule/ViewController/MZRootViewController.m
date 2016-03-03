//
//  MZRootViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/6.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZRootViewController.h"
#import "MRGuideViewController.h"
@interface MZRootViewController ()

@end

@implementation MZRootViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if ([userdefaultsDefine boolForKey:@"firstCreatedAlbumView"] == YES) {
//        [MRGuideViewController show];
//        [userdefaultsDefine setBool:NO forKey:@"firstCreatedAlbumView"];
//    }
//
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //去掉导航栏底下的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
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
