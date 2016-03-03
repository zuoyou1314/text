//
//  MZDynamicViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/20.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDynamicViewController.h"
#import "MZDynamicListViewController.h"
#import "MZWeChatViewController.h"
#import "BaiduMobStat.h"
#import "MZPhotoAlbumDetailViewController.h"
@interface MZDynamicViewController ()
{
      BOOL _eventAlbumInfo;
}
@end

@implementation MZDynamicViewController

- (instancetype)initWithAlbum_id:(NSString *)album_id album_name:(NSString *)album_name;
{
    self = [super init];
    if (self) {
        self.album_id = album_id;
        self.album_name = album_name;
        MZDynamicListViewController *dynamicListVC = [[MZDynamicListViewController alloc]initWithAlbum_id:album_id album_name:album_name];
        [self addChildViewController:dynamicListVC];
        MZWeChatViewController *wechatVC = [[MZWeChatViewController alloc]initWithAlbum_id:album_id album_name:album_name];
        [self addChildViewController:wechatVC];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor purpleColor];
    
    self.title = _album_name;
    UIButton *rightButton = [UIButton createButtonWithNormalImage:@"main_manage" highlitedImage:nil target:self action:@selector(didClickRightBarAction)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
//    self.segmentedControl.frame = CGRectMake(0, 64-64, SCREEN_WIDTH, 40);
//    self.lineLabel.frame = rect(0, 64+40-64, SCREEN_WIDTH, 0.5);
    
    
}

- (void)didClickRightBarAction
{
    NSLog(@"相册详情");
    [[BaiduMobStat defaultStat] logEvent:@"albumInfo" eventLabel:@"照片列表页-相册信息入口"];
    if(!_eventAlbumInfo) {
        _eventAlbumInfo = YES;
        [[BaiduMobStat defaultStat] eventStart:@"albumInfo" eventLabel:@"照片列表页-相册信息入口"];
    } else {
        _eventAlbumInfo = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"albumInfo" eventLabel:@"照片列表页-相册信息入口"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"albumInfo" eventLabel:@"照片列表页-相册信息入口" durationTime:1000];
    
    MZPhotoAlbumDetailViewController *photoAlbumDetailVC = [[MZPhotoAlbumDetailViewController alloc]init];
    photoAlbumDetailVC.album_id = self.album_id;
//    photoAlbumDetailVC.user_id = self.uid;
    photoAlbumDetailVC.cover_img = self.cover_img;
    [self.navigationController pushViewController:photoAlbumDetailVC animated:YES];
    
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
