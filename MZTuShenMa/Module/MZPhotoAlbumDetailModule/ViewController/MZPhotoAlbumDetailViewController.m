//
//  MZPhotoAlbumDetailViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/27.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZPhotoAlbumDetailViewController.h"

#import "MZHeadInfoCollectionViewCell.h"
#import "MZPhotoAlbumNameView.h"
#import "MZExitPhotoView.h"
#import "MZAddFriendViewController.h"
#import "MZPushNotificationView.h"
#import "MZPhotoAlbumDetailsParam.h"
#import "MZAlbumMembersModel.h"
#import "MZUserAlbumDetailsModel.h"


#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "MZPhotoAlbumUserNameView.h"
#import "MZPhotoAlbumShowNameView.h"
#import "MZModifyInfoViewController.h"
#import "MZDeleteAlbumMemberParam.h"
#import "MZPhotoListViewController.h"
#import "MZMainViewController.h"
#import "UIImageView+WebCache.h"
#import "MZInviteFriendView.h"
#import "MZExitAlbumView.h"
#import "MZAlbumQRCodeView.h"
#import "MZAlbumDescriptionView.h"
#import "MZCreateQRCodeViewController.h"
#define HEADINFOOFWIDTH ([UIScreen mainScreen].bounds.size.width-20)

@interface MZPhotoAlbumDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MZExitPhotoViewDelegate,MZPushNotificationViewDelegate,MZExitAlbumViewDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_membersArray;
    NSMutableArray *_detailsArray;
    MZPhotoAlbumNameView *_photoAlbumNameView;
    BOOL _eventUserAvatar;
    BOOL _eventAddMember;
}
@end

@implementation MZPhotoAlbumDetailViewController

static NSString * const mzHeadInfoCollectionViewCellIdentifier = @"headInfoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册信息";
    [self setLeftBarButton];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    if ([userdefaultsDefine boolForKey:@"firstInviteFriendView"] == YES) {
        MZInviteFriendView *inviteFriendView = [[MZInviteFriendView alloc]init];
        inviteFriendView.frame = [UIScreen mainScreen].bounds;
        [inviteFriendView show];
        [userdefaultsDefine setBool:NO forKey:@"firstInviteFriendView"];
    }
}

- (void)initData
{
    __weak typeof(self) weakSelf = self;
    MZPhotoAlbumDetailsParam *photoAlbumDetailsParam = [[MZPhotoAlbumDetailsParam alloc]init];
    photoAlbumDetailsParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    photoAlbumDetailsParam.album_id = self.album_id;
    NSLog(@"photoAlbumDetailsParam.album_id == %@",photoAlbumDetailsParam.album_id);
    NSLog(@"photoAlbumDetailsParam.user_id == %@",photoAlbumDetailsParam.user_id);
    [self showHoldView];
    [MZRequestManger albumDetailsRequest:photoAlbumDetailsParam success:^(NSArray *albumMembers,NSArray *userAlbumDetails) {
        [weakSelf hideHUD];
        //        NSLog(@"albumMembers=%@,userAlbumDetails=%@",albumMembers,userAlbumDetails);
        _membersArray = [NSMutableArray arrayWithCapacity:albumMembers.count];
        for (NSDictionary *dic in albumMembers) {
            MZAlbumMembersModel *dataModel = [MZAlbumMembersModel objectWithKeyValues:dic];
            [_membersArray addObject:dataModel];
        }
        _detailsArray = [NSMutableArray arrayWithCapacity:userAlbumDetails.count];
        for (NSDictionary *dic in userAlbumDetails) {
            MZUserAlbumDetailsModel *dataModel = [MZUserAlbumDetailsModel objectWithKeyValues:dic];
            [_detailsArray addObject:dataModel];
        }
        [self initUI];
        //        [_collectionView reloadData];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
}



- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rect(0.0f,0.0f,SCREEN_WIDTH,SCREEN_HEIGHT)];
    scrollView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.view addSubview:scrollView];
    
    //创建一个布局样式
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    NSUInteger heightOfNumber;
//    if (_membersArray.count/3.0>_membersArray.count/3) {
    heightOfNumber =_membersArray.count/4+1;
//    }else{
//        heightOfNumber = _membersArray.count/3;
//    }
    
//    if (2/3.0>2/3) {
//        heightOfNumber =2/3+1;
//    }else{
//        heightOfNumber = 2/3;
//    }
    
//    NSLog(@"number = %d",9/4.0);
//    NSLog(@"heightOfNumber = %ld",heightOfNumber);
    
//    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, HEADINFOOFWIDTH/4*heightOfNumber) collectionViewLayout:layout];
//    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 100*heightOfNumber) collectionViewLayout:layout];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 85*heightOfNumber+15) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    //注册标识
    [_collectionView registerClass:[MZHeadInfoCollectionViewCell class]  forCellWithReuseIdentifier:mzHeadInfoCollectionViewCellIdentifier];

    //分割线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:rect(0, 85*heightOfNumber+15, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = RGB(206, 206, 206);
    [scrollView addSubview:lineLabel];
    
    MZUserAlbumDetailsModel *dataModel;
    if (_detailsArray.count >0) {
        dataModel = [_detailsArray objectAtIndex:0];
    }

    
    //相册名称
    _photoAlbumNameView = [[MZPhotoAlbumNameView alloc]initWithFrame:CGRectMake(0, _collectionView.frame.size.height + 10.0f, SCREEN_WIDTH, 45.0f)];
    _photoAlbumNameView.albumName.text = dataModel.album_name;
    [scrollView addSubview:_photoAlbumNameView];
    UITapGestureRecognizer *photoAlbumNameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickPhotoAlbumNameViewAction:)];
    [_photoAlbumNameView addGestureRecognizer:photoAlbumNameTap];
    //相册二维码
    MZAlbumQRCodeView *qrCodeView = [[MZAlbumQRCodeView alloc]initWithFrame:CGRectMake(0,_photoAlbumNameView.frame.origin.y+_photoAlbumNameView.frame.size.height, SCREEN_WIDTH, 45.0f)];
    [scrollView addSubview:qrCodeView];
    UITapGestureRecognizer *qrCodeViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickQRCodeViewAction:)];
    [qrCodeView addGestureRecognizer:qrCodeViewTap];
    //相册描述
    MZAlbumDescriptionView *albumDescriptionView = [[MZAlbumDescriptionView alloc]initWithFrame:CGRectMake(0, qrCodeView.frame.origin.y+qrCodeView.frame.size.height, SCREEN_WIDTH, 45.0f)];
    albumDescriptionView.albumDescriptionLabel.text = dataModel.album_des;
    [scrollView addSubview:albumDescriptionView];
    UITapGestureRecognizer *albumDescriptionViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickAlbumDescriptionViewAction:)];
    [albumDescriptionView addGestureRecognizer:albumDescriptionViewTap];

    
    
    //我在本群的昵称
    MZPhotoAlbumUserNameView *userNameView = [[MZPhotoAlbumUserNameView alloc]initWithFrame:rect(0, albumDescriptionView.frame.origin.y + albumDescriptionView.frame.size.height +20.0f, SCREEN_WIDTH, 45.0f)];
    [scrollView addSubview:userNameView];
    userNameView.userNameLabel.text = dataModel.uname;
    UITapGestureRecognizer *userNameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickPhotoAlbumUserNameViewAction:)];
    [userNameView addGestureRecognizer:userNameTap];
    
    //显示群成员昵称
//    MZPhotoAlbumShowNameView *showView = [[MZPhotoAlbumShowNameView alloc]initWithFrame:rect(0, userNameView.frame.origin.y + userNameView.frame.size.height, SCREEN_WIDTH, 45.0f)];
//    [scrollView addSubview:showView];
//    showView.showUserNameSwitch.on =[dataModel.is_name integerValue];
    
    //推送
    MZPushNotificationView *pushView = [[MZPushNotificationView alloc]initWithFrame:CGRectMake(0, userNameView.frame.size.height + userNameView.frame.origin.y +20.0f, SCREEN_WIDTH, 70.0f)];
    pushView.delegate = self;
    NSLog(@"dataModel.push = %@",dataModel.push);
    if ([dataModel.push isEqualToString:@"0"]) {
        pushView.pushSwitch.on =1;
    }else{
        pushView.pushSwitch.on =0;
    }
    
    
    [scrollView addSubview:pushView];
   
    
//    if (_membersArray.count/4.0>2) {
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 4*heightOfNumber+20.0f);
//    }else{
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
//    
//    
//    MZExitPhotoView *exitView = [[MZExitPhotoView alloc]initWithFrame:CGRectMake(0, scrollView.contentSize.height-50.0f-20.0f-64.0f, SCREEN_WIDTH,50.0f)];
//    exitView.delegate = self;
//    [scrollView addSubview:exitView];
    
    
    
//    if (heightOfNumber>2) {
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT-50) + HEADINFOOFWIDTH/4*(heightOfNumber-2));
//    }else{
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
//    NSLog(@"heightOfNumber == %ld",heightOfNumber);
    if (heightOfNumber>2 || heightOfNumber ==2) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT-50) + 85*(heightOfNumber-2)+15+100);
    }else{
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    //退出相册
    MZExitPhotoView *exitView = [[MZExitPhotoView alloc]initWithFrame:CGRectMake(0, scrollView.contentSize.height-45.0f-64.0f, SCREEN_WIDTH,45.0f)];
    exitView.delegate = self;
    [scrollView addSubview:exitView];
    
}



#pragma mark ---- MZExitPhotoViewDelegate
- (void)clickExitButtonAction
{
    MZExitAlbumView *exitAlbumView =[[MZExitAlbumView alloc]init];
    exitAlbumView.frame = [UIScreen mainScreen].bounds;
    exitAlbumView.delegate = self;
    [exitAlbumView show];
}


- (void)clickExitAlbumButtonEvent
{
    __weak typeof(self) weakSelf = self;
    MZDeleteAlbumMemberParam *deleteAlbumMemberParam = [[MZDeleteAlbumMemberParam alloc]init];
    deleteAlbumMemberParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    deleteAlbumMemberParam.album_id = self.album_id;
    deleteAlbumMemberParam.del_id = [userdefaultsDefine objectForKey:@"user_id"];
    [self showHoldView];
    [MZRequestManger deleteAlbumemberRequest:deleteAlbumMemberParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            return ;
        }
        MZMainViewController *mainVC = [[MZMainViewController alloc]init];
        [self.navigationController pushViewController:mainVC animated:YES];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
}


#pragma mark ---- MZPushNotificationViewDelegate

- (void)clickPushSkitch:(UISwitch *)pushSwitch
{
    MZEditAlbumParam *editAlbumParam = [[MZEditAlbumParam alloc]init];
    editAlbumParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    editAlbumParam.album_id = self.album_id;
    
    if (pushSwitch.on == 1) {
        editAlbumParam.push = @"0";
    }else{
        editAlbumParam.push = @"1";
    }

    
    [self showHoldView];
     __weak typeof(self) weakSelf = self;
    [MZRequestManger editAlbumRequest:editAlbumParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            return ;
        }
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
    
}


#pragma mark ---- UICollectionViewDataSourc`e

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _membersArray.count+1;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(HEADINFOOFWIDTH/4, 85);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _membersArray.count) {
        MZHeadInfoCollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:mzHeadInfoCollectionViewCellIdentifier forIndexPath:indexPath];
        addCell.headImage.image = [UIImage imageNamed:@"main_head_add"];
        addCell.nameLabel.hidden = YES;
        addCell.backgroundColor = [UIColor whiteColor];
        return addCell;
        
    }else{
        MZAlbumMembersModel *dataModel = [_membersArray objectAtIndex:indexPath.row];
        MZHeadInfoCollectionViewCell *headInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:mzHeadInfoCollectionViewCellIdentifier forIndexPath:indexPath];
        headInfoCell.backgroundColor =[UIColor whiteColor];
        headInfoCell.membersModel = dataModel;
        
        return headInfoCell;
    }
  
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
     MZUserAlbumDetailsModel *userAlbumDetailsModel = [_detailsArray objectAtIndex:0];
    
    if (indexPath.row == _membersArray.count) {
//        MZAddFriendViewController *addFriendVC = [[MZAddFriendViewController alloc]init];
//        [self.navigationController pushViewController:addFriendVC animated:YES];
        
        [[BaiduMobStat defaultStat] logEvent:@"addMember" eventLabel:@"相册信息页-添加用户"];
        if(!_eventAddMember) {
            _eventAddMember = YES;
            [[BaiduMobStat defaultStat] eventStart:@"addMember" eventLabel:@"相册信息页-添加用户"];
        } else {
            _eventAddMember = NO;
            [[BaiduMobStat defaultStat] eventEnd:@"addMember" eventLabel:@"相册信息页-添加用户"];
        }
        [[BaiduMobStat defaultStat] logEventWithDurationTime:@"addMember" eventLabel:@"相册信息页-添加用户" durationTime:1000];
        
       
        __weak typeof(self) weakSelf = self;
        UIImageView *sharImage = [[UIImageView alloc] init];
        [sharImage sd_setImageWithURL:[NSURL URLWithString:self.cover_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            NSString *url = [NSString stringWithFormat:@"%@:%@/%@?%@=%@&album_id=%@",kHost,kPort,kAddAlbumMember,AUTHCODE,[kAddAlbumMember base64Encode],weakSelf.album_id];

            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"邀请您加入《%@》",userAlbumDetailsModel.album_name];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
            [socialControllerService setShareText:[NSString stringWithFormat:@"与朋友一起分享《%@》美好时光",userAlbumDetailsModel.album_name] shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(weakSelf,socialControllerService,YES);

        }];

        
        
          }else{
        NSLog(@"跳转相册");
              [[BaiduMobStat defaultStat] logEvent:@"userAvatar" eventLabel:@"所有-用户头像"];
              if(!_eventUserAvatar) {
                  _eventUserAvatar = YES;
                  [[BaiduMobStat defaultStat] eventStart:@"userAvatar" eventLabel:@"所有-用户头像"];
              } else {
                  _eventUserAvatar = NO;
                  [[BaiduMobStat defaultStat] eventEnd:@"userAvatar" eventLabel:@"所有-用户头像"];
              }
              [[BaiduMobStat defaultStat] logEventWithDurationTime:@"albumInfo" eventLabel:@"所有-用户头像" durationTime:1000];
              MZAlbumMembersModel *dataModel = [_membersArray objectAtIndex:indexPath.row];
              MZPhotoListViewController *photoListVC = [[MZPhotoListViewController alloc]init];
              photoListVC.album_memId = dataModel.uid;
              photoListVC.album_id = self.album_id;
              photoListVC.album_name = userAlbumDetailsModel.album_name;
              photoListVC.uname = dataModel.user_name;
              photoListVC.albumType = MZPhotoListViewControllerTypeNormal;
              [self.navigationController pushViewController:photoListVC animated:YES];
              
              
    }
    
    //    MDWGirlModel *girl=[_girls objectAtIndex:[indexPath row]];
    //    MDWGirlInfoViewController *mmStarVC = [[MDWGirlInfoViewController alloc] initWithGirlId:girl.girlid];
    //    mmStarVC.isFromMeView = NO;
    //    [self pushViewController:mmStarVC];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)didClickPhotoAlbumNameViewAction:(UITapGestureRecognizer *)tap
{
    MZModifyInfoViewController *modifyInfoVC =[[MZModifyInfoViewController alloc]init];
    modifyInfoVC.titles = @"相册名称";
    modifyInfoVC.textFieldString = _photoAlbumNameView.albumName.text;
    modifyInfoVC.album_id = self.album_id;
    [self.navigationController pushViewController:modifyInfoVC animated:YES];
}

- (void)didClickQRCodeViewAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"生成二维码");
    MZCreateQRCodeViewController *qrCodeVC = [[MZCreateQRCodeViewController alloc]initWithAlbumId:self.album_id];
    [self.navigationController pushViewController:qrCodeVC animated:YES];
}

- (void)didClickAlbumDescriptionViewAction:(UITapGestureRecognizer *)tap
{
    MZModifyInfoViewController *modifyInfoVC =[[MZModifyInfoViewController alloc]init];
    MZUserAlbumDetailsModel *dataModel = [_detailsArray objectAtIndex:0];
    modifyInfoVC.titles = @"相册描述";
    modifyInfoVC.textFieldString = dataModel.album_des;
    modifyInfoVC.album_id = self.album_id;
    [self.navigationController pushViewController:modifyInfoVC animated:YES];
}


- (void)didClickPhotoAlbumUserNameViewAction:(UITapGestureRecognizer *)tap
{
    MZModifyInfoViewController *modifyInfoVC =[[MZModifyInfoViewController alloc]init];
    MZUserAlbumDetailsModel *dataModel = [_detailsArray objectAtIndex:0];
    modifyInfoVC.titles = @"我在本群的昵称";
    modifyInfoVC.textFieldString = dataModel.uname;
    modifyInfoVC.album_id = self.album_id;
    [self.navigationController pushViewController:modifyInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"相册信息页"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"相册信息页"];
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
